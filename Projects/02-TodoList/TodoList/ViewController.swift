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
    let identifierUserDataCell = "UserData"
    
    var rowData = Variable<[String]>(["NunnyMumi"])
    
	override func viewDidLoad() {
		super.viewDidLoad()
		setRegisterTableViewCell()
        
        rowData
            .asObservable()
            .subscribe(onNext: { [weak self](_) in
                self?.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)
        
        addButton
            .rx
            .tap
            .asObservable()
            .map { (_) -> String in
                return "Nunny"
            }.withLatestFrom(rowData.asObservable()) { (newData, oldData) -> [String] in
                var result = oldData
                //result.append(contentsOf: newData)
                result.append(newData)
                return result
            }
            .bind(to: rowData)
            .addDisposableTo(disposeBag)
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    private func setRegisterTableViewCell(){
        tableView.register(UserDataTableViewCell.classForCoder(), forCellReuseIdentifier: identifierUserDataCell)
        tableView.register(UINib(nibName:"UserDataTableViewCell",bundle:nil), forCellReuseIdentifier: identifierUserDataCell)
    }
    
}

extension ViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rowData.value.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserDataTableViewCell? = tableView.dequeueReusableCell(withIdentifier:identifierUserDataCell, for: indexPath) as? UserDataTableViewCell
        cell?.nameLabel.text = rowData.value[indexPath.row]
		return cell!
	}
}
