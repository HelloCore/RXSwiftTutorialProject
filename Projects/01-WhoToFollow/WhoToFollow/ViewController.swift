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
	
    lazy var viewModel: ViewModelType = {
        return ViewModel()
    }()
	private let disposeBag = DisposeBag()
	
    let refreshControl = UIRefreshControl()
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        tableView.addSubview(refreshControl)
        
        
        refreshControl
            .rx
            .controlEvent(UIControlEvents.valueChanged)
            .subscribe(onNext: { [weak self](_) in
                self?.viewModel.input.onRefreshButtonTap()
            })
            .addDisposableTo(disposeBag)
        
        
        viewModel
            .output
            .isLoading
            .asDriver()
            .drive(onNext: { (isLoading) in
                self.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)
        
        viewModel
            .output
            .result
            .asDriver()
            .drive(onNext: { [weak self] (_) in
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            })
            .addDisposableTo(disposeBag)
	}
    
    @IBAction func refreshBtnClicked(_ sender: Any) {
        viewModel.input.onRefreshButtonTap()
    }
}

extension ViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.output.isLoading.value == true {
            return viewModel.output.result.value.count + 1
        }
        return viewModel.output.result.value.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == viewModel.output.result.value.count {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "LOADING_CELL")
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.startAnimating()
            cell.addSubview(indicator)
            
            indicator.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            indicator.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            indicator.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
            indicator.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
      
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: GithubUserTableViewCell.cellIdentifier,
                                                     for: indexPath) as! GithubUserTableViewCell
            let model = viewModel.output.result.value[indexPath.row]
            cell.configureCellWithModel(model)
            return cell
        }
	}
}

extension ViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (viewModel.output.result.value.count - 1) {
            viewModel.input.onLoadMore()
        }
	}
}

