//
//  MyCalculatorTests.swift
//  MyCalculatorTests
//
//  Created by MECHIN on 8/15/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import XCTest

@testable import MyCalculator

class MyCalculatorTests: XCTestCase {
    
    var viewModel: MainViewModelType!
    
    override func setUp() {
        super.setUp()
        
        viewModel = MainViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        viewModel = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func testExample() {
        
//        viewModel.inputs.onNumberBtnTap("1")
//        viewModel.inputs.onNumberBtnTap("2")
//        viewModel.inputs.onNumberBtnTap("3")
//        
//        viewModel.outputs.resultForDisplay
        
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
}
