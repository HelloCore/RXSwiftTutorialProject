//
//  ViewController.swift
//  LoginExample
//
//  Created by AKKHARAWAT CHAYAPIWAT on 6/24/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import Moya
import Moya_ObjectMapper

class ViewController: UIViewController {

	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	
	@IBOutlet var tapGesture: UITapGestureRecognizer!
	
	
	@IBOutlet weak var mainSwitch: UISwitch!
	@IBOutlet weak var mainLabel: UILabel!
	
	@IBOutlet weak var leftLabel: UILabel!
	
	@IBOutlet weak var rightLabel: UILabel!
	
	@IBOutlet weak var rightButton: UIButton!

	@IBOutlet weak var leftButton: UIButton!
	
	let disposeBag = DisposeBag()
	
	private lazy var viewModel: ViewModel = {
		let input = ViewModelInputs(usernameText: self.usernameTextField.rx.text.orEmpty.asObservable(),
		                            passwordText: self.passwordTextField.rx.text.orEmpty.asObservable(),
		                            loginBtnTap: self.loginButton.rx.tap.asObservable(),
		                            tapGesture: self.tapGesture.rx.event.asObservable().map { _ in return () })
		return ViewModel(input: input)
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let leftLabelVar = Variable<String>("0")
		leftButton.rx.tap.asDriver()
			.scan(0) { (oldValue, _) -> Int in
				return oldValue + 1
			}
			.map { "\($0)" }
			.do(onNext: { [leftLabel](str) in
				leftLabel?.text = str
			})
			.drive(leftLabelVar)
			.addDisposableTo(disposeBag)
		
		
		let rightLabelVar = Variable<String>("0")
		rightButton.rx.tap.asDriver()
			.scan(0) { (oldValue, _) -> Int in
				return oldValue + 1
			}
			.map { "\($0)" }
			.do(onNext: { [rightLabel](str) in
				rightLabel?.text = str
			})
			.drive(rightLabelVar)
			.addDisposableTo(disposeBag)
		
		mainSwitch.rx.isOn
			.flatMapLatest({ (isOn) -> Observable<String> in
				if isOn {
					return rightLabelVar.asObservable().replay(1).ifEmpty(switchTo: <#T##Observable<String>#>)
				}else{
					return leftLabelVar.asObservable().replay(1)
				}
			})
			.asDriver(onErrorJustReturn: "XXXX")
			.drive(mainLabel.rx.text)
			.addDisposableTo(disposeBag)
		
		
		
		viewModel
			.outputs
			.isLoading
			.subscribeOn(MainScheduler.instance)
			.subscribe(onNext: { (isLoading) in
				if isLoading {
					SVProgressHUD.show()
				}else{
					SVProgressHUD.popActivity()
				}
			})
			.addDisposableTo(disposeBag)
		
		viewModel
			.outputs
			.isLoginEnabled
			.subscribeOn(MainScheduler.instance)
			.bind(to: loginButton.rx.isEnabled)
			.addDisposableTo(disposeBag)
	
		
		viewModel
			.outputs
			.onLoginSuccess
			.subscribeOn(MainScheduler.instance)
			.subscribe(onNext: {  [weak self] (response) in
				let alertController = UIAlertController(title: "Success", message: "Welcome \(response.name ?? "")", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
				self?.present(alertController, animated: true)
			})
			.addDisposableTo(disposeBag)
		
		viewModel
			.outputs
			.onRequestShowAlertMessage
			.subscribeOn(MainScheduler.instance)
			.subscribe(onNext: {  [weak self] (message) in
				let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
				self?.present(alertController, animated: true)
			})
			.addDisposableTo(disposeBag)
		
		viewModel
			.outputs
			.onRequestEndEditing
			.subscribeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] (_) in
				self?.view.endEditing(true)
			})
			.addDisposableTo(disposeBag)
		
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

