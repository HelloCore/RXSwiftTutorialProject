//
//  ViewModel.swift
//  LoginExample
//
//  Created by AKKHARAWAT CHAYAPIWAT on 6/24/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Moya_ObjectMapper

protocol ViewModelInputs {
	func onUsernameTextChange(_ username: String)
	func onPasswordTextChange(_ password: String)
	func onLoginBtnTap()
	func onTapGestureTap()
}

protocol ViewModelOutputs {
	var isLoginEnabled: Observable<Bool>! { get }
	
	var onLoginSuccess: Observable<LoginResponse>! { get }
	var onRequestShowAlertMessage: Observable<String>! { get }
	
	var isLoading: Observable<Bool>! { get }
	var onRequestEndEditing: Observable<Void>! { get }
}

protocol ViewModelType {
	var inputs: ViewModelInputs { get }
	var outputs: ViewModelOutputs { get }
}

class ViewModel: ViewModelType, ViewModelOutputs, ViewModelInputs {
	
	var isLoading: Observable<Bool>! {
		return loading.asObservable()
	}
	
	var isLoginEnabled: Observable<Bool>!
	
	var onLoginSuccess: Observable<LoginResponse>!
	var onRequestShowAlertMessage: Observable<String>!
	
	var onRequestEndEditing: Observable<Void>!
	
	private var loading = PublishSubject<Bool>()
	
	private let provider = MoyaProvider<LoginService>(stubClosure: MoyaProvider.delayedStub(1))
	
	init() {
		
		let isUsernameValid = _onUsernameTextChange
			.map { (username) -> Bool in
				return username.count >= 4
			}
		
		let isPasswordValid = _onPasswordTextChange
			.map { (password) -> Bool in
				return password.count >= 4
			}
		
		isLoginEnabled = Observable
			.combineLatest(
				isUsernameValid,
				isPasswordValid
			) { (usrValid, pwdValid) -> Bool in
				return usrValid && pwdValid
			}
		
		let loginService = Observable
			.combineLatest(
				_onUsernameTextChange,
				_onPasswordTextChange
			) { (usr, pwd) -> LoginService in
				return LoginService.login(username: usr, password: pwd)
			}
		
		let loginResponse = _onLoginBtnTap
			.withLatestFrom(loginService)
			.do(onNext: { [weak self] (_) in
				self?.loading.onNext(true)
			})
			.flatMapLatest { [provider](service) -> Observable<LoginResponse> in
				return provider.rx
					.request(service)
					.mapObject(LoginResponse.self)
					.asObservable()
			}
			.catchError({ (error) -> Observable<LoginResponse> in
				return Observable.just(LoginResponse(JSON: error.json)!)
			})
			.do(onNext: { (_) in
				self.loading.onNext(false)
			})
			.share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
		
		onLoginSuccess = loginResponse.filter { $0.responseStatus == .success }
		onRequestShowAlertMessage = loginResponse
			.filter { $0.responseStatus != .success }
			.map { $0.message ?? "Unknown Error" }
		
		
		onRequestEndEditing = _onTapGestureTap
	}
	
	private let _onUsernameTextChange = BehaviorSubject<String>(value: "")
	func onUsernameTextChange(_ username: String) {
		_onUsernameTextChange.onNext(username)
	}
	
	private let _onPasswordTextChange = BehaviorSubject<String>(value: "")
	func onPasswordTextChange(_ password: String) {
		_onPasswordTextChange.onNext(password)
	}
	
	private let _onLoginBtnTap = PublishSubject<Void>()
	func onLoginBtnTap() {
		_onLoginBtnTap.onNext(())
	}
	
	private let _onTapGestureTap = PublishSubject<Void>()
	func onTapGestureTap() {
		_onTapGestureTap.onNext(())
	}
	
	var inputs: ViewModelInputs { return self }
	var outputs: ViewModelOutputs { return self }
}
