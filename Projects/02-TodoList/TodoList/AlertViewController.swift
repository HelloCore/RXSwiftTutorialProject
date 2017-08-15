 //
//  AlertViewController.swift
//  TodoList
//
//  Created by MECHIN on 6/23/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
 
public class AlertViewController: UIViewController {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var onAddTodoModel: Observable<TodoModel>!
    let disposeBag = DisposeBag()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField
            .rx
            .text
            .orEmpty
            .asObservable()
            .map { (text) -> Bool in
                return text.isEmpty == false
            }
            .bind(to: okButton.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
         cancelButton
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [weak self] () in
                self?.dismiss(animated: true, completion: nil)
            }).addDisposableTo(disposeBag)
        
        onAddTodoModel = okButton
            .rx
            .tap
            .asObservable()
            .withLatestFrom(inputTextField.rx.text.orEmpty.asObservable())
            .map { (text) -> TodoModel in
                return TodoModel(title: text, isCompleted: false)
            }.do(onNext: { [weak self](_) in
                self?.dismiss(animated: true)
            })
        
        
        
        
        
        // Do any additional setup after loading the view.
        
    }
    
    deinit {
        print("deinit")
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
