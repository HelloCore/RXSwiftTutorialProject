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
    case mutiply
}

protocol MainViewModelInputs {
    func onOperatorBtnTap(_ oper: MyOperator)
    func onNumberBtnTap(_ number: String)
    func onClearBtnTap()
    func onEqualBtnTap()
    
}

protocol MainViewModelOutputs {
    var resultForDisplay: Driver<String> { get }
    var isBtnOperatorEnabled: Driver<Bool> { get }
    var isBtnEqualEnabled: Driver<Bool> { get }
}

protocol MainViewModelType {
	var inputs: MainViewModelInputs { get }
	var outputs: MainViewModelOutputs { get }
}

class MainViewModel: MainViewModelType, MainViewModelInputs, MainViewModelOutputs {
	
    // output
    var resultForDisplay: Driver<String> {
        return currentResult.asDriver()
    }
    var isBtnOperatorEnabled: Driver<Bool> {
        return btnOperatorIsEnabled.asDriver()
    }
    var isBtnEqualEnabled: Driver<Bool> {
        return btnEqualIsEnabled.asDriver()
    }
    
    private var oldResult: String?
    private var currentOperator: MyOperator?
    private var currentResult = Variable<String>("0")
    private var btnEqualIsEnabled = Variable<Bool>(false)
    private var btnOperatorIsEnabled = Variable<Bool>(true)
    private var shouldClear = false
    
    let disposeBag = DisposeBag()
    
	init() {
        
        numberBtnTap
            .withLatestFrom(currentResult.asObservable()) { (numberFromBtn: $0, lastResult: $1) }
            .map { (obj) -> String in
                if obj.lastResult == "0" {
                    if self.shouldClear {
                        self.shouldClear = false
                        return obj.numberFromBtn
                    }
                    return obj.numberFromBtn
                }else{
                    if self.shouldClear {
                        self.shouldClear = false
                       return obj.numberFromBtn
                    }else{
                        return obj.lastResult.appending(obj.numberFromBtn)
                    }
                }
            }
            .bind(to: currentResult)
            .addDisposableTo(disposeBag)
        
        operatorBtnTap
            .withLatestFrom(currentResult.asObservable()) { (operFromBtn: $0, lastResult: $1) }
            .do(onNext: { (obj) in
                self.oldResult = obj.lastResult
                self.currentOperator = obj.operFromBtn
                self.btnEqualIsEnabled.value = true
                self.btnOperatorIsEnabled.value = false
            })
            .map { _ in "0" }
            .bind(to: currentResult)
            .addDisposableTo(disposeBag)
        
        
        equalBtnTap.withLatestFrom(currentResult.asObservable())
            .map { (lastResult) -> String in
                if let oper = self.currentOperator {
                    
                    var oldValue = Int(self.oldResult!)!
                    let newValue = Int(lastResult)!
                    switch oper {
                    case .minus:
                        oldValue = oldValue - newValue
                        break
                    case .mutiply:
                        oldValue = oldValue * newValue
                        break
                    case .plus:
                        oldValue = oldValue + newValue
                        break
                    }
                    return ("\(oldValue)")
                }else {
                    return lastResult
                }
            }
            .do(onNext: { (_) in
                self.shouldClear = true
                self.btnOperatorIsEnabled.value = true
                self.btnEqualIsEnabled.value = false
            })
            .bind(to: currentResult)
            .addDisposableTo(disposeBag)
        
        
        clearBtnTap
            .do(onNext: { (_) in
                self.btnEqualIsEnabled.value = false
                self.btnOperatorIsEnabled.value = true

            })
            .map { (_) -> String in
                return "0"
            }
            .bind(to: currentResult)
            .addDisposableTo(disposeBag)
	}
    
    private let operatorBtnTap = PublishSubject<MyOperator>()
    func onOperatorBtnTap(_ oper: MyOperator) {
        operatorBtnTap.onNext(oper)
    }
    
    private let numberBtnTap = PublishSubject<String>()
    func onNumberBtnTap(_ number: String) {
        numberBtnTap.onNext(number)
    }
    
    private let clearBtnTap = PublishSubject<Void>()
    func onClearBtnTap() {
        clearBtnTap.onNext(())
    }
    
    private let equalBtnTap = PublishSubject<Void>()
    func onEqualBtnTap() {
        equalBtnTap.onNext(())
    }
    	
	var inputs: MainViewModelInputs { return self }
	var outputs: MainViewModelOutputs { return self }
}
