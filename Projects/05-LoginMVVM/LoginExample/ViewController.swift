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
	
	private var viewModel: ViewModelType!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = ViewModel()
		
		self.bindInputs()
		self.bindOutputs()
	}
	
	private func bindInputs() {
		usernameTextField.rx.text.orEmpty
			.bind(onNext: viewModel.inputs.onUsernameTextChange)
			.disposed(by: disposeBag)
		
		passwordTextField.rx.text.orEmpty
			.bind(onNext: viewModel.inputs.onPasswordTextChange)
			.disposed(by: disposeBag)
		
		loginButton.rx.tap.asObservable()
			.bind(onNext: viewModel.inputs.onLoginBtnTap)
			.disposed(by: disposeBag)
		
		tapGesture.rx.event.asObservable()
			.map { _ in ()}
			.bind(onNext: viewModel.inputs.onTapGestureTap)
			.disposed(by: disposeBag)
	}
	
	private func bindOutputs() {
		
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
			.disposed(by: disposeBag)
		
		viewModel
			.outputs
			.isLoginEnabled
			.subscribeOn(MainScheduler.instance)
			.bind(to: loginButton.rx.isEnabled)
			.disposed(by: disposeBag)
		
		
		viewModel
			.outputs
			.onLoginSuccess
			.subscribeOn(MainScheduler.instance)
			.subscribe(onNext: {  [weak self] (response) in
				let alertController = UIAlertController(title: "Success", message: "Welcome \(response.name ?? "")", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
				self?.present(alertController, animated: true)
			})
			.disposed(by: disposeBag)
		
		viewModel
			.outputs
			.onRequestShowAlertMessage
			.subscribeOn(MainScheduler.instance)
			.subscribe(onNext: {  [weak self] (message) in
				let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
				self?.present(alertController, animated: true)
			})
			.disposed(by: disposeBag)
		
		viewModel
			.outputs
			.onRequestEndEditing
			.subscribeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] (_) in
				self?.view.endEditing(true)
			})
			.disposed(by: disposeBag)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

