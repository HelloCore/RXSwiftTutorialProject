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

    @IBOutlet weak var tfTask: UITextField!
    @IBOutlet weak var viewAddTask: UIView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var addTaskBtn: UIButton!
    @IBOutlet weak var cancelTaskBtn: UIButton!
    var listTodo = Variable<[TodoObject]>([])
	let disposeBag = DisposeBag()
    var dataSource = Variable<[TodoModel]>([])
    
	override func viewDidLoad() {
		super.viewDidLoad()
//==================================================
        listTodo
            .asObservable()
            .subscribe(onNext: { [weak self] (_) in
                self?.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)
//==================================================
        addButton
            .rx
            .tap
            .asObservable()
            .subscribe{[weak self] _ in
                self?.viewAddTask.isHidden = false
        }.addDisposableTo(disposeBag)
//==================================================

        cancelTaskBtn
        .rx.tap.asObservable()
        .subscribe { [weak self] _ in
            self?.tfTask.text = nil
            self?.viewAddTask.isHidden = true
            self?.addTaskBtn.isEnabled = false
            
        }.addDisposableTo(disposeBag)
//==================================================

        tfTask
        .rx.text.orEmpty.asObservable()
        .map { (str) -> Bool in
            return str.isEmpty == false
        }
        .bind(to: addTaskBtn.rx.isEnabled)
        .addDisposableTo(disposeBag)

//==================================================

        addTaskBtn
            .rx
            .tap
            .asObservable()
            .withLatestFrom(self.tfTask.rx.text.orEmpty.asObservable())
            .map { (tex) -> TodoObject in
                let todo = TodoObject()
                todo.isComplete = false
                todo.name = tex
                return todo
            }.withLatestFrom(listTodo.asObservable()) { (todoObj, todoList) -> [TodoObject] in
                var newList = todoList
                newList.append(todoObj)
                return newList
            }
            .do(onNext: { (_) in
                self.viewAddTask.isHidden = true
                self.tfTask.text = nil
                self.addTaskBtn.isEnabled = false

            })
            .bind(to: listTodo)
            .addDisposableTo(disposeBag)
        
    }

        
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

extension ViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listTodo.value.count
    }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell
        cell.lbl.text = listTodo.value[indexPath.row].name
        
        
        cell.btnComplete.rx.tap.asObservable().map { () -> TodoObject in
            
            let todo = self.listTodo.value[indexPath.row]

            if(todo.isComplete)! {
                cell.btnComplete.setBackgroundImage((UIImage(named: "unCheck")), for: UIControlState.normal)
                cell.lbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)


            }else {
                cell.lbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                cell.btnComplete.setBackgroundImage((UIImage(named: "check")), for: UIControlState.normal)
                
                print("@iscom")
                
            }
            todo.isComplete = !todo.isComplete!

          return todo
        }.withLatestFrom(listTodo.asObservable()) { (todoObj, todoList) -> [TodoObject] in
            var newList = todoList
            newList[indexPath.row] = todoObj
            return newList
        }.bind(to: listTodo)
        .addDisposableTo(cell.disposeBag)
        
		return cell
	}
}


