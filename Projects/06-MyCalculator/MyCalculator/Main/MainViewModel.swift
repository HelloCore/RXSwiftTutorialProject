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
    func onCheckBracketsBtnTap(_ brackets: String)
}

protocol MainViewModelOutputs {
    var resultForDisplay: Driver<String> { get }
    var resultCheck: Driver<Bool> { get }

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
    var resultCheck: Driver<Bool>{
        return result.asDriver()
    }
    private var result = Variable<Bool>(false)

    private var currentResult = Variable<String>("0")

    var arrOpenBrackets:[String] = ["{","[","(","<"]
    var arrCloseBrackets:[String] = ["}","]",")",">"]

    var operatorSelect = Variable<MyOperator>(.plus)
    var number1:Int = 0
    var number2:Int = 0
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
        
        clearBtnTap
            .map { (_) -> String in
                self.number1 = 0
                self.number2 = 0
                return "0"
            }
            .bind(to: currentResult)
            .addDisposableTo(disposeBag)
        
        operatorBtnTap
            .do(onNext: { (_) in
                if self.number2 == 0{
                    self.number1 = Int(self.currentResult.value)!
                    self.currentResult.value = "0"
                }else{
                    self.number1 = Int(self.currentResult.value)!
                    self.currentResult.value = ""
                }
            })
            .bind(to: operatorSelect)
            .addDisposableTo(disposeBag)
        
        equalBtnTap
            .do(onNext: { (_) in
                self.number2 = Int(self.currentResult.value)!
            })
            .withLatestFrom(currentResult.asObservable())
            .map{(obj) -> String in
                var result:Int = 0
                switch self.operatorSelect.value {
                case .plus:
                    result = Int(self.number1) + Int(self.number2)
                    return "\(result)"
                case .minus:
                    result = Int(self.number1) - Int(self.number2)
                    return "\(result)"
                case .mutiply:
                    result = Int(self.number1) * Int(self.number2)
                    return "\(result)"
                case .divide:
                    if Int(self.number2) == 0{
                        return "Error"
                    }
                    result = Int(self.number1) / Int(self.number2)
                    return "\(result)"
                }
            }
            .bind(to: currentResult)
            .addDisposableTo(disposeBag)
        
        
        bracketsBtnTap
//            .withLatestFrom(result.asObservable()) { (numberFromBtn: $0, lastResult: $1) }
//
//        for char in str.characters {
//            print("Found character: \(char)")
//        }
            .do(onNext: { (_) in
                for char in self.result.value {
                    print("Found character: \(char)")
                }
            })
//        result
        
        
	}
    
    private let operatorBtnTap = PublishSubject<MyOperator>()
    func onOperatorBtnTap(_ oper: MyOperator){
        operatorBtnTap.onNext(oper)
    }
    
    private let clearBtnTap = PublishSubject<Void>()
    func onClearBtnTap(){
        clearBtnTap.onNext(())
    }
    
    private let equalBtnTap = PublishSubject<Void>()
    func onEqualBtnTap(){
        equalBtnTap.onNext(())
    }
    
	
	private let numberBtnTap = PublishSubject<String>()
	func onNumberBtnTap(_ number: String){
		numberBtnTap.onNext(number)
	}
    
    private let bracketsBtnTap = PublishSubject<String>()
    func onCheckBracketsBtnTap(_ brackets: String){
        bracketsBtnTap.onNext(brackets)
    }
    
	
	var inputs: MainViewModelInputs { return self }
	var outputs: MainViewModelOutputs { return self }
}
