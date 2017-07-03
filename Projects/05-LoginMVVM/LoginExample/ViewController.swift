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

	@IBOutlet weak var usernameTextFIeld: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	
	@IBOutlet var tapGesture: UITapGestureRecognizer!
	
	let disposeBag = DisposeBag()
	
	var viewModel: ViewModel!
	
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
			.loginResponse
			.subscribeOn(MainScheduler.instance)
			.subscribe(onNext: {  [weak self](response) in
				var alertController: UIAlertController
				if response.responseStatus == .success {
					alertController = UIAlertController(title: "Success", message: "Welcome \(response.name ?? "")", preferredStyle: .alert)
				}else{
					alertController = UIAlertController(title: "Error", message: response.message ?? "Unknown Error", preferredStyle: .alert)
				}
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

