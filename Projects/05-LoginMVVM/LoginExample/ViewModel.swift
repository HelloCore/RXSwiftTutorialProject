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

struct ViewModelInputs {
	let usernameText: Observable<String>
	let passwordText: Observable<String>
	let loginBtnTap: Observable<Void>
	let tapGesture: Observable<Void>
}

protocol ViewModelOutputs {
	var isLoginEnabled: Observable<Bool>! { get }
	var loginResponse: Observable<LoginResponse>! { get }
	var isLoading: Observable<Bool>! { get }
	var onRequestEndEditing: Observable<Void>! { get }
}

class ViewModel: ViewModelOutputs {
	
	var outputs: ViewModelOutputs { return self }
	
	var isLoading: Observable<Bool>! {
		return loading.asObservable()
	}
	
	var isLoginEnabled: Observable<Bool>!
	var loginResponse: Observable<LoginResponse>!
	var onRequestEndEditing: Observable<Void>!
	
	private var loading = PublishSubject<Bool>()
	
	init(input: ViewModelInputs) {
		
		let isUsernameValid = input.usernameText
			.map { (username) -> Bool in
				return username.characters.count >= 4
		}
		
		let isPasswordValid = input.passwordText
			.map { (password) -> Bool in
				return password.characters.count >= 4
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
				input.usernameText,
				input.passwordText
			) { (usr, pwd) -> LoginService in
				return LoginService.login(username: usr, password: pwd)
			}
		
		loginResponse = input.loginBtnTap
			.withLatestFrom(loginService)
			.do(onNext: { [weak self] (_) in
				self?.loading.onNext(true)
			})
			.flatMapLatest { (service) -> Observable<LoginResponse> in
				let provider = RxMoyaProvider<LoginService>(stubClosure: RxMoyaProvider.delayedStub(1))
				return provider
					.request(service)
					.mapObject(LoginResponse.self)
			}
			.catchError({ (error) -> Observable<LoginResponse> in
				return Observable.just(LoginResponse(JSON: error.json)!)
			})
			.do(onNext: { (_) in
				self.loading.onNext(false)
			})
		
		onRequestEndEditing = input.tapGesture				
	}
}
