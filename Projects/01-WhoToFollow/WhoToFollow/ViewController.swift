//
//  ViewController.swift
//  WhoToFollow
//
//  Created by AKKHARAWAT CHAYAPIWAT on 6/20/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import Moya_ObjectMapper
import SVProgressHUD
import Alamofire

class ViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var refreshBtn: UIBarButtonItem!
	
	var rowData = Variable<[GithubUser]>([])
	var fetchingTrigger = PublishSubject<Void>()
	
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		refreshBtn
			.rx.tap
			.asObservable()
			.map { (_) -> [GithubUser] in
				return []
			}
			.observeOn(MainScheduler.instance)
			.bind(to: self.rowData)
			.addDisposableTo(disposeBag)
		
		let rowDataAsObserable = rowData.asObservable()
		
		let offsetCount = rowDataAsObserable
			.map { (users) in return users.count }
		
		fetchingTrigger
			.observeOn(MainScheduler.instance)
			.do(onNext: { (_) in
				SVProgressHUD.show()
			})
			.withLatestFrom(offsetCount)
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
			.withLatestFrom( rowDataAsObserable, resultSelector:
				{ (newData, oldData) -> [GithubUser] in
					var result = oldData
					result.append(contentsOf: newData)
					return result
				})
			.observeOn(MainScheduler.instance)
			.do(onNext: { (_) in
				SVProgressHUD.popActivity()
			})
			.bind(to: rowData)
			.addDisposableTo(disposeBag)
		
		rowData
			.asObservable()
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] (data) in
				if data.count == 0 {
					self?.fetchingTrigger.onNext(())
				}
				self?.tableView.reloadData()
			})
			.addDisposableTo(disposeBag)
	}
}

extension ViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rowData.value.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: GithubUserTableViewCell.cellIdentifier, for: indexPath) as! GithubUserTableViewCell
		let model = rowData.value[indexPath.row]
		cell.configureCellWithModel(model)
		return cell
	}
}

extension ViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == (rowData.value.count - 1) {
			fetchingTrigger.onNext(())
		}
	}
}
