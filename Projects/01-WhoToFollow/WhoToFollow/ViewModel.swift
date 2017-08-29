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

protocol ViewModelInputs {
    func onRefreshButtonTap()
    func onLoadMore(_ indexPath: IndexPath)
    
}

protocol ViewModelOutputs {
    var result: Variable<[GithubUser]> { get }
    
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
    private var allUsers = Variable<[GithubUser]>([])
    
    let disposeBag = DisposeBag()
    
    init() {
        
        if let obj = GithubUser(JSON: ["login" : "hello"]) {
            allUsers.value.append(obj)
        }
        
    }
    
    private let refreshBtnTap = PublishSubject<Void>()
    func onRefreshButtonTap() {
        refreshBtnTap
            .asObservable()
            .startWith(())
            .map { (_) -> [GithubUser] in
                return []
        }
        
        Observable.merge([
            loadMoreTrigger.asObserver(),
            refreshBtnTap.map { _ in return () }
            ])
            .do(onNext: { (_) in
                
            })
            .withLatestFrom(allUsers.asObservable())
            .map { (rowData) -> Int in
                return self.allUsers.value.count
            }
            .flatMap { (offset) -> Observable<[GithubUser]> in
                let provider = RxMoyaProvider<GithubService>()
                return provider.request(GithubService.getUser(offset: offset)).mapArray(GithubUser.self)
                
            }.withLatestFrom(allUsers.asObservable()) { (newUsers, oldUsers) -> [GithubUser] in
                var result = oldUsers
                result.append(contentsOf: newUsers)
                return result
        }
        .bind(to: allUsers)
        .addDisposableTo(disposeBag)
    }
    
    private let loadMoreTrigger = PublishSubject<Void>()
    func onLoadMore(_ indexPath: IndexPath) {
        if indexPath.row == allUsers.value.count - 1 {
            loadMoreTrigger.onNext(())
        }
    }
    
    var input: ViewModelInputs { return self }
    var output: ViewModelOutputs { return self }
}
