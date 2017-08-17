//
//  MyCalculatorTests.swift
//  MyCalculatorTests
//
//  Created by Benz on 8/15/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import XCTest
import Nimble
import RxTest
import RxSwift
import RxCocoa

@testable import MyCalculator

class MyCalculatorTests: XCTestCase {
	
	var viewModel: MainViewModelType!
	var scheduler: TestScheduler!
	var disposeBag: DisposeBag!
	
    override func setUp() {
        super.setUp()
		
		viewModel = MainViewModel()
		scheduler = TestScheduler(initialClock: 0)
		disposeBag = DisposeBag()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
		
		viewModel = nil
		scheduler = nil
		disposeBag = nil
		
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testDefaultNumber() {
		let resultObserver = scheduler.createObserver(String.self)
		driveOnScheduler(scheduler) {
			viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
		}
		
		scheduler.start()
		expect(resultObserver.events.count).to(equal(1))
		expect(resultObserver.events.first?.value.element).to(equal("0"))
		
	}
	
	func test1NumberInput() {
		let resultObserver = scheduler.createObserver(String.self)
		driveOnScheduler(scheduler) { 
			viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
			
			viewModel.inputs.onNumberBtnTap("1")
		}
		
		scheduler.start()
		
		expect(resultObserver.events.count).to(equal(2))
		expect(resultObserver.events.last?.value.element).to(equal("1"))
	}
	
	func test2NumberInput() {
		let resultObserver = scheduler.createObserver(String.self)
		driveOnScheduler(scheduler) {
			viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
			
			viewModel.inputs.onNumberBtnTap("1")
			viewModel.inputs.onNumberBtnTap("2")
		}
		
		scheduler.start()
		
		expect(resultObserver.events.count).to(equal(3))
		expect(resultObserver.events.last?.value.element).to(equal("12"))
	}
	
	func test10NumberInput() {
        let resultObserver = scheduler.createObserver(String.self)
		driveOnScheduler(scheduler) {
			viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
			
			viewModel.inputs.onNumberBtnTap("1")
			viewModel.inputs.onNumberBtnTap("2")
			viewModel.inputs.onNumberBtnTap("3")
			viewModel.inputs.onNumberBtnTap("4")
			viewModel.inputs.onNumberBtnTap("5")
			viewModel.inputs.onNumberBtnTap("6")
			viewModel.inputs.onNumberBtnTap("7")
			viewModel.inputs.onNumberBtnTap("8")
			viewModel.inputs.onNumberBtnTap("9")
			viewModel.inputs.onNumberBtnTap("0")
		}
		
		scheduler.start()
        
		expect(resultObserver.events.count).to(equal(11))
		expect(resultObserver.events.last?.value.element).to(equal("1234567890"))
	}
	
	func testZero() {
		let resultObserver = scheduler.createObserver(String.self)
		driveOnScheduler(scheduler) {
			viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
			
			viewModel.inputs.onNumberBtnTap("0")
		}
		
		scheduler.start()
		
		expect(resultObserver.events.count).to(equal(2))
		expect(resultObserver.events.last?.value.element).to(equal("0"))
	}
	
	func testStartWithZero() {
		let resultObserver = scheduler.createObserver(String.self)
		driveOnScheduler(scheduler) {
			viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
			
			viewModel.inputs.onNumberBtnTap("0")
			viewModel.inputs.onNumberBtnTap("1")
		}
		
		scheduler.start()
		
		expect(resultObserver.events.count).to(equal(3))
		expect(resultObserver.events.last?.value.element).to(equal("1"))
	}
	
    //MARK: Test plus
    func test1NumberWithOperatorPlusInput() {
        let resultObserver = scheduler.createObserver(String.self)
        driveOnScheduler(scheduler) {
            viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
            
            viewModel.inputs.onNumberBtnTap("1")
            viewModel.inputs.onOperatorBtnTap(MyOperator.plus)
        }
        
        scheduler.start()
        expect(resultObserver.events.last?.value.element).to(equal("0"))
    }
    
    func test2NumberWithOperatorPlusInput() {
        let resultObserver = scheduler.createObserver(String.self)
        driveOnScheduler(scheduler) {
            viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
            
            viewModel.inputs.onNumberBtnTap("1")
            viewModel.inputs.onOperatorBtnTap(MyOperator.plus)
            viewModel.inputs.onNumberBtnTap("1")
        }
        
        scheduler.start()
        expect(resultObserver.events.last?.value.element).to(equal("1"))

    }
    
    func test2NumberWithOperatorPlusInputAndEqualInput() {
        let resultObserver = scheduler.createObserver(String.self)
        driveOnScheduler(scheduler) {
            viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
            
            viewModel.inputs.onNumberBtnTap("1")
            viewModel.inputs.onOperatorBtnTap(MyOperator.plus)
            viewModel.inputs.onNumberBtnTap("1")
            viewModel.inputs.onEqualBtnTap()
        }
        
        scheduler.start()
        expect(resultObserver.events.last?.value.element).to(equal("2"))
    }
    
    func test3NumberWithOperatorPlusInputAndEqualInput() {
        let resultObserver = scheduler.createObserver(String.self)
        driveOnScheduler(scheduler) {
            viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
            
            viewModel.inputs.onNumberBtnTap("1")
            viewModel.inputs.onOperatorBtnTap(MyOperator.plus)
            viewModel.inputs.onNumberBtnTap("1")
            viewModel.inputs.onEqualBtnTap()
            viewModel.inputs.onOperatorBtnTap(MyOperator.plus)
            viewModel.inputs.onNumberBtnTap("2")
            viewModel.inputs.onNumberBtnTap("0")
            viewModel.inputs.onEqualBtnTap()
        }
        
        scheduler.start()
        expect(resultObserver.events.last?.value.element).to(equal("22"))
    }

    
    //MARK: Test minus
    func test1NumberWithOperatorMinusInput() {
        let resultObserver = scheduler.createObserver(String.self)
        driveOnScheduler(scheduler) {
            viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
            
            viewModel.inputs.onNumberBtnTap("1")
            viewModel.inputs.onOperatorBtnTap(MyOperator.minus)
        }
        
        scheduler.start()
        expect(resultObserver.events.last?.value.element).to(equal("0"))
    }
	
    func test2NumberWithOperatorMinusInput() {
        let resultObserver = scheduler.createObserver(String.self)
        driveOnScheduler(scheduler) {
            viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
            
            viewModel.inputs.onNumberBtnTap("1")
            viewModel.inputs.onOperatorBtnTap(MyOperator.minus)
            viewModel.inputs.onNumberBtnTap("1")
            viewModel.inputs.onEqualBtnTap()
        }
        
        scheduler.start()
        
        expect(resultObserver.events.last?.value.element).to(equal("0"))
    }
    
    //MARK: Test multiply
    func test1NumberWithOperatorMultiplyInput() {
        let resultObserver = scheduler.createObserver(String.self)
        driveOnScheduler(scheduler) {
            viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
            
            viewModel.inputs.onNumberBtnTap("1")
            viewModel.inputs.onOperatorBtnTap(MyOperator.mutiply)
        }
        
        scheduler.start()
        expect(resultObserver.events.last?.value.element).to(equal("0"))
    }
    
    func test2NumberWithOperatorMultiplyInput() {
        let resultObserver = scheduler.createObserver(String.self)
        driveOnScheduler(scheduler) {
            viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
            
            viewModel.inputs.onNumberBtnTap("1")
            viewModel.inputs.onOperatorBtnTap(MyOperator.mutiply)
            viewModel.inputs.onNumberBtnTap("1")
        }
        
        scheduler.start()
        expect(resultObserver.events.last?.value.element).to(equal("1"))
    }
    
    func test2NumberWithOperatorMutiplyInputAndEqualInput() {
        let resultObserver = scheduler.createObserver(String.self)
        driveOnScheduler(scheduler) {
            viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
            
            viewModel.inputs.onNumberBtnTap("1")
            viewModel.inputs.onOperatorBtnTap(MyOperator.mutiply)
            viewModel.inputs.onNumberBtnTap("1")
            viewModel.inputs.onEqualBtnTap()
        }
        
        scheduler.start()
        expect(resultObserver.events.last?.value.element).to(equal("1"))
    }
   
    
    //MARK: CLEAR 
    func test1NumberWithClearInput() {
        let resultObserver = scheduler.createObserver(String.self)
        driveOnScheduler(scheduler) {
            viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
            
            viewModel.inputs.onNumberBtnTap("1")
            viewModel.inputs.onClearBtnTap()
        }
        
        scheduler.start()
        expect(resultObserver.events.last?.value.element).to(equal("0"))
    }
    
    //MARK: Operator Enabled
    func testOperatorPlusInput() {
        let resultObserver = scheduler.createObserver(String.self)
        let isOperEnableObserver = scheduler.createObserver(Bool.self)
        let isEqualEnableObserver = scheduler.createObserver(Bool.self)
        driveOnScheduler(scheduler) {
            viewModel.outputs.isBtnOperatorEnabled.drive(isOperEnableObserver).addDisposableTo(disposeBag)
            viewModel.outputs.isBtnEqualEnabled.drive(isEqualEnableObserver).addDisposableTo(disposeBag)
            viewModel.outputs.resultForDisplay.drive(resultObserver).addDisposableTo(disposeBag)
            
            viewModel.inputs.onOperatorBtnTap(MyOperator.plus)
        }
        
        scheduler.start()
        expect(resultObserver.events.last?.value.element).to(equal("0"))
        expect(isOperEnableObserver.events.last?.value.element).to(equal(false))
        expect(isEqualEnableObserver.events.last?.value.element).to(equal(true))
    }
    
}
