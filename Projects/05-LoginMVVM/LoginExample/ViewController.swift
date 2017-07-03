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
		
		// Username: hellocore
		// Password: anything
		
		let input = ViewModelInputs(usernameText: usernameTextFIeld.rx.text.orEmpty.asObservable(),
		                            passwordText: passwordTextField.rx.text.orEmpty.asObservable(),
		                            loginBtnTap: loginButton.rx.tap.asObservable(),
		                            tapGesture: tapGesture.rx.event.asObservable().map { _ in return () })
		
		viewModel = ViewModel(input: input)
		
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

