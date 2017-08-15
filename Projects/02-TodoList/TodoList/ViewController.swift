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
    
    var rowData = Variable<[PersonObject]>([])
    var isCheckToDoList: Bool = false
    
    
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
            .map { UIAlertController.addDataAlert() }
            .flatMapLatest { [weak self](result) -> Observable<String> in
                self?.present(result.alert , animated: true)
                return result.onTap
            }
            .map { (text) -> PersonObject in
                let personalModel = PersonObject()
                personalModel.employeeName = text
                return personalModel
            }
            .withLatestFrom(self.rowData.asObservable()) { (newData, oldData) -> [PersonObject] in
                var result = oldData
                result.append(newData)
                return result
            }
            .bind(to: self.rowData)
            .addDisposableTo(disposeBag)
        
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    private func setRegisterTableViewCell() {
        tableView.register(UserDataTableViewCell.classForCoder(), forCellReuseIdentifier: identifierUserDataCell)
        tableView.register(UINib(nibName:"UserDataTableViewCell",bundle:nil), forCellReuseIdentifier: identifierUserDataCell)
    }
}

extension ViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rowData.value.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserDataTableViewCell = tableView.dequeueReusableCell(withIdentifier:identifierUserDataCell, for: indexPath) as! UserDataTableViewCell
        let model = rowData.value[indexPath.row]
        cell.nameLabel.text = model.employeeName
        cell.checkBoxImage?.image = (model.checkList) ?  #imageLiteral(resourceName: "CheckBox"): #imageLiteral(resourceName: "UnCheckBox")
        
        cell.toDoBtn
            .rx
            .tap
            .asObservable()
            .map { () -> PersonObject in
                let personAtIndex = self.rowData.value[indexPath.row]
                personAtIndex.checkList = !personAtIndex.checkList
                return personAtIndex
        }.withLatestFrom(self.rowData.asObservable()) { (currentData, oldData) -> [PersonObject] in
            var newdata = oldData
            newdata[indexPath.row] = currentData
            return newdata
        }.bind(to: rowData)
        .addDisposableTo(cell.disposeBag)
        
		return cell
	}
}

extension UIAlertController {
    
    static func addDataAlert() -> (alert: UIAlertController, onTap: Observable<String>) {
        
        let subject = PublishSubject<String>()
        
        let alert = UIAlertController(title: "Add Data", message: "Please add your name", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            let textField = alert.textFields![0]
            if let text = textField.text,
                text.characters.count > 0 {
                subject.onNext(text)
            }
        }))
        
        return (alert: alert, onTap: subject.asObservable())
    }
}
