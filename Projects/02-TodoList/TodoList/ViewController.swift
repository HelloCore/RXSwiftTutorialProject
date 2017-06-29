//
//  ViewController.swift
//  TodoList
//
//  Created by AKKHARAWAT CHAYAPIWAT on 6/20/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class ViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var addButton: UIBarButtonItem!
	
	let disposeBag = DisposeBag()
    var dataSource = Variable<[TodoModel]>([])
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44
        initialSubScription()
    }
    
    func initialSubScription() {
        dataSource
            .asObservable()
            .subscribe(onNext: { [weak self] (_) in
                self?.tableView.reloadData()
            }).addDisposableTo(disposeBag)
        
        addButton
            .rx
            .tap
            .asObservable()
            .flatMapLatest({ [weak self] (_) -> Observable<TodoModel> in
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: AlertViewController.self))
                let vc = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
                self?.present(vc, animated: true)
                return vc.onAddTodoModel
            })
            .withLatestFrom(dataSource.asObservable()) { (item, oldDataSource) -> [TodoModel] in
                var newSource = oldDataSource
                newSource.append(item)
                return newSource
            }
            .bind(to: dataSource)
            .addDisposableTo(disposeBag)
        
        // when user selected item at index todo title will be gray Label
        tableView
            .rx
            .itemSelected
            .asObservable()
            .withLatestFrom(self.dataSource.asObservable(), resultSelector: { (indexPath, data) -> [TodoModel] in
                var rowData = data
                var model = rowData[indexPath.row]
                model.isCompleted = !model.isCompleted
                rowData[indexPath.row] = model
                return rowData
            })
            .bind(to: dataSource)
            .addDisposableTo(disposeBag)
    }
    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

extension ViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource.value.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
        let todoModel = dataSource.value[indexPath.row]
        if todoModel.isCompleted {
            let attributedString = NSAttributedString(string: todoModel.title,
                                                      attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSStrikethroughStyleAttributeName: 1])
            cell.textLabel?.attributedText = attributedString
        }else {
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.text = todoModel.title

        }
		return cell
	}
}


