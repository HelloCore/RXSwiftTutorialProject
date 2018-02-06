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
	
	let disposeBag = DisposeBag()
	
	var rowData = BehaviorSubject<[GithubUser]>(value: [])
	
	var loadMoreTrigger = PublishSubject<Void>()
	let provider = MoyaProvider<GithubService>()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		rowData
			.subscribe(onNext: { [weak self](_) in
				self?.tableView.reloadData()
			})
			.disposed(by: disposeBag)
		
		let onRefreshBtn = refreshBtn
			.rx
			.tap
			.asObservable()
			.startWith(())
			.map { (_) -> [GithubUser] in
				return []
			}
		
		onRefreshBtn
			.bind(to: rowData)
			.disposed(by: disposeBag)
		
		Observable.merge([
				loadMoreTrigger.asObserver(),
				onRefreshBtn.map{ _ in return () }
			])
			.do(onNext: { (_) in
				SVProgressHUD.show()
			})
			.withLatestFrom(rowData.asObserver())
			.map({ (rowData) -> Int in
				return rowData.count
			})
			.flatMap { [provider] (rowCount) -> Single<[GithubUser]> in
				return provider.rx
					.request(
						GithubService.getUser(offset: rowCount)
					)
					.mapArray(GithubUser.self)
					.catchError { _ in
						return Single.just([])
					}
			}
			.withLatestFrom(rowData.asObserver()) { (newData, oldData) -> [GithubUser] in
				var result = oldData
				result.append(contentsOf: newData)
				return result
			}
			.do(onNext: { (_) in
				SVProgressHUD.dismiss()
			})
			.observeOn(MainScheduler.instance)
			.subscribeOn(MainScheduler.instance)
			.bind(to: rowData)
			.disposed(by: disposeBag)
	}
}

extension ViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (try? rowData.value().count) ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: GithubUserTableViewCell.cellIdentifier, for: indexPath) as! GithubUserTableViewCell
		if let model = try? rowData.value()[indexPath.row] {
			cell.configureCellWithModel(model)
		}
		return cell
	}
}

extension ViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let rowDatXa = try? rowData.value(),
			indexPath.row == (rowDatXa.count - 1) {
			loadMoreTrigger.onNext(())
		}
	}
}
