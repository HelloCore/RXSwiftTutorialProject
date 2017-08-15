//
//  MainViewModel.swift
//  MyCalculator
//
//  Created by Benz on 8/15/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelInputs {
	func onNumberBtnTap(_ number: String)
}

protocol MainViewModelOutputs {
	var result: Driver<String> { get }
}

protocol MainViewModelType {
	var inputs: MainViewModelInputs { get }
	var outputs: MainViewModelOutputs { get }
}

class MainViewModel: MainViewModelType, MainViewModelInputs, MainViewModelOutputs {
	
	var result: Driver<String> {
		return currentResult.asDriver()
	}
	
	private var currentResult = Variable<String>("0")
	private let disposeBag = DisposeBag()
	
	init() {
		numberBtnTap
			.withLatestFrom(currentResult.asObservable()) { (number: $0, lastResult: $1) }
			.map { (obj) -> String in
				if obj.lastResult == "0" {
					return obj.number
				}else{
					return obj.lastResult.appending(obj.number)
				}
			}
			.bind(to: currentResult)
			.addDisposableTo(disposeBag)
	}
	
	private let numberBtnTap = PublishSubject<String>()
	func onNumberBtnTap(_ number: String){
		numberBtnTap.onNext(number)
	}
	
	var inputs: MainViewModelInputs { return self }
	var outputs: MainViewModelOutputs { return self }
}
