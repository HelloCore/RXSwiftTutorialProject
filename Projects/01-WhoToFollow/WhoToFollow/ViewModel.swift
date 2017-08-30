//
//  ViewModel.swift
//  WhoToFollow
//
//  Created by MECHIN on 8/29/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import Moya_ObjectMapper
import Alamofire


protocol ViewModelInputs {
    func onRefreshButtonTap()
    func onLoadMore()
}

protocol ViewModelOutputs {
    var result: Variable<[GithubUser]> { get }
    var isLoading: Variable<Bool> { get }
}

protocol ViewModelType {
    var input: ViewModelInputs { get }
    var output: ViewModelOutputs { get }
}

class ViewModel: ViewModelType, ViewModelInputs, ViewModelOutputs {
    
    // output
    var result: Variable<[GithubUser]> {
        return allUsers
    }
    
    var isLoading = Variable<Bool>(false)
    
    private var allUsers = Variable<[GithubUser]>([])
    private var isNoMoreData = false

    let disposeBag = DisposeBag()
    
    init() {
        
        let offsetFromRefresh = refreshBtnTap
            .startWith(())
            .map { (_) -> [GithubUser] in
                return []
            }
            .do(onNext: { [weak self] (obj) in
                self?.allUsers.value = obj
            })
            .map { $0.count }
        
        let offsetFromLoadMore = loadMoreTrigger.withLatestFrom(self.allUsers.asObservable())
            .map { $0.count }
        
        Observable.merge([ offsetFromRefresh, offsetFromLoadMore ])
            .withLatestFrom(self.isLoading.asObservable(), resultSelector: { (offset: $0, isLoading: $1 ) })
            .filter { $0.isLoading == false }
            .do(onNext: { [weak self](_) in
                self?.isLoading.value = true
            })
            .map { $0.offset }
            .observeOn(SerialDispatchQueueScheduler(qos: DispatchQoS.background))
            .flatMap { (userCount) -> Observable<[GithubUser]> in
                let configuration = URLSessionConfiguration.default
                configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
                configuration.requestCachePolicy = .reloadIgnoringCacheData
                let provider = RxMoyaProvider<GithubService>(manager: SessionManager(configuration: configuration))
                return provider
                    .request(
                        .getUser(offset: userCount)
                    )
                    .mapArray(GithubUser.self)
            }
            .withLatestFrom( allUsers.asObservable(), resultSelector:
                { (newData, oldData) -> [GithubUser] in
                    var result = oldData
                    result.append(contentsOf: newData)
                    return result
            })
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self](_) in
                self?.isLoading.value = false
            })
            .bind(to: allUsers)
            .addDisposableTo(disposeBag)
        
        
    }
    
    private let refreshBtnTap = PublishSubject<Void>()
    func onRefreshButtonTap() {
        refreshBtnTap.onNext(())
    }
    
    private let loadMoreTrigger = PublishSubject<Void>()
    func onLoadMore() {
        loadMoreTrigger.onNext(())
    }
    
    var input: ViewModelInputs { return self }
    var output: ViewModelOutputs { return self }
}
