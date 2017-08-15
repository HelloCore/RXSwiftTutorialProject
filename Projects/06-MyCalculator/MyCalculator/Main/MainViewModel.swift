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
    case divide
}

protocol MainViewModelInputs {
    func onOperatorBtnTap(_ oper: MyOperator)
    func onNumberBtnTap(_ number: String)
    func onClearBtnTap()
    func onEqualBtnTap()
    
}

protocol MainViewModelOutputs {
    var resultForDisplay: Driver<String> { get }
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
    
    private var currentResult = Variable<String>("0")
    
    let disposeBag = DisposeBag()
    
	init() {
        
        numberBtnTap
            .withLatestFrom(currentResult.asObservable()) { (numberFromBtn: $0, lastResult: $1) }
            .map { (obj) -> String in
                if obj.lastResult == "0" {
                    return obj.numberFromBtn
                }else{
                    return obj.lastResult.appending(obj.numberFromBtn)
                }
            }
            .bind(to: currentResult)
            .addDisposableTo(disposeBag)
	}
    
    private let operatorBtnTap = PublishSubject<MyOperator>()
    func onOperatorBtnTap(_ oper: MyOperator){
        operatorBtnTap.onNext(oper)
    }
    
    private let numberBtnTap = PublishSubject<String>()
    func onNumberBtnTap(_ number: String){
        numberBtnTap.onNext(number)
    }
    
    private let clearBtnTap = PublishSubject<Void>()
    func onClearBtnTap(){
        clearBtnTap.onNext(())
    }
    
    private let equalBtnTap = PublishSubject<Void>()
    func onEqualBtnTap(){
        equalBtnTap.onNext(())
    }
    
	
	var inputs: MainViewModelInputs { return self }
	var outputs: MainViewModelOutputs { return self }
}
