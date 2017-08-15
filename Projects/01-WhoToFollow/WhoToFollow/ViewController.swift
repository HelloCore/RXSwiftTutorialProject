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
	
//	BehaviorSubject<ArrayList<GithubUser>> rowData
//		= BehaviorSubject<ArrayList<GithubUser>>.create([]);
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		rowData
			.subscribe(onNext: { [weak self](_) in
				self?.tableView.reloadData()
			})
			.addDisposableTo(disposeBag)
		
		if let obj = GithubUser(JSON: ["login" : "hello"]) {
			rowData.onNext([obj])
		}
		
//		
//		let onRefreshBtn = refreshBtn
//			.rx
//			.tap
//			.asObservable()
//			.startWith(())
//			.map { (_) -> [GithubUser] in
//				return []
//			}
//		
//		onRefreshBtn
//			.bind(to: rowData)
//			.addDisposableTo(disposeBag)
//		
//		Observable.merge([
//				loadMoreTrigger.asObserver(),
//				onRefreshBtn.map{ _ in return () }
//			])
//			.do(onNext: { (_) in
//				SVProgressHUD.show()
//			})
//			.withLatestFrom(rowData.asObserver())
//			.map({ (rowData) -> Int in
//				return rowData.count
//			})
//			.flatMap { (rowCount) -> Observable<[GithubUser]> in
//				let provider = RxMoyaProvider<GithubService>()
//				return provider.request(
//						GithubService.getUser(offset: rowCount)
//					).mapArray(GithubUser.self)
//			}.withLatestFrom(rowData.asObserver()) { (newData, oldData) -> [GithubUser] in
//				var result = oldData
//				result.append(contentsOf: newData)
//				return result
//			}
//			.do(onNext: { (_) in
//				SVProgressHUD.dismiss()
//			})
//			.bind(to: rowData)
//			.addDisposableTo(disposeBag)
//		
		
//		refreshBtn
//			.rx
//			.tap
//			.asObservable()
//			.map { (_) -> GithubUser in
//				return GithubUser(JSON: ["login": "5555"])!
//			}
//			.withLatestFrom(rowData.asObservable(),
//			                 resultSelector: { (obj1, obj2) -> [GithubUser] in
//								var newUsers = obj2
//								newUsers.append(obj1)
//								return newUsers
//							})
//			.bind(to: rowData)
//			.addDisposableTo(disposeBag)
		
		
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
