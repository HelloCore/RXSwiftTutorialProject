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

enum MyOperator {
	case plus
	case minus
	case multiply
	
	func operate(_ left: String, right: String) -> String {
		let oldValue = Int(left)!
		let newValue = Int(right)!
		
		switch self {
		case .minus:
			return "\(oldValue - newValue)"
		case .multiply:
			return "\(oldValue * newValue)"
		case .plus:
			return "\(oldValue + newValue)"
		}
		
	}
}

protocol MainViewModelInputs {
	func onNumberBtnTap(_ number: String)
	func onOperatorBtnTap(_ oper: MyOperator)
	func onEqualBtnTap()
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
	
	
	private var oldResult = "0"
	private var oldOperator = MyOperator.plus
	private var shouldClear = true
	
	private var currentResult = Variable<String>("0")
	private let disposeBag = DisposeBag()
	
	init() {
		
		numberBtnTap
			.withLatestFrom(currentResult.asObservable()) { (number: $0, lastResult: $1) }
			.map { (obj) -> String in
				if self.shouldClear == true {
					self.shouldClear = false
					return obj.number
				}else{
					if obj.lastResult == "0" {
						return obj.number
					}else{
						return obj.lastResult.appending(obj.number)
					}
				}
			}
			.bind(to: currentResult)
			.addDisposableTo(disposeBag)
		
		operatorTap
			.withLatestFrom(currentResult.asObservable()) { (oper: $0, currentResult: $1) }
			.map { (obj) -> (oper: MyOperator, result: String) in
				return (oper: obj.oper, result: obj.oper.operate(self.oldResult, right: obj.currentResult))
			}
			.do(onNext: { (obj) in
				self.shouldClear = true
				self.oldResult = obj.result
				self.oldOperator = obj.oper
			})
			.map { $0.result }
			.bind(to: currentResult)
			.addDisposableTo(disposeBag)
		
//		equalTap
//			.withLatestFrom(currentResult.asObservable()) { (oper: $0, currentResult: $1) }
//			.map { (obj) -> (oper: MyOperator, result: String) in
//				return (oper: obj.oper, result: obj.oper.operate(self.oldResult, right: obj.currentResult))
//			}
		
	}
	
	private let numberBtnTap = PublishSubject<String>()
	func onNumberBtnTap(_ number: String){
		numberBtnTap.onNext(number)
	}
	
	private let operatorTap = PublishSubject<MyOperator>()
	func onOperatorBtnTap(_ oper: MyOperator){
		operatorTap.onNext(oper)
	}
	
	private let equalTap = PublishSubject<Void>()
	func onEqualBtnTap(){
		equalTap.onNext(())
	}
	
	
	var inputs: MainViewModelInputs { return self }
	var outputs: MainViewModelOutputs { return self }
}
