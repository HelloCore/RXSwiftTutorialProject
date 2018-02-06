//
//  TestViewModel.swift
//  MyCalculator
//
//  Created by Benz on 9/12/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TestViewModelInputs {

}

protocol TestViewModelOutputs {

}

protocol TestViewModelType {
    var inputs: TestViewModelInputs { get }
    var outputs: TestViewModelOutputs { get }
}

class TestViewModel: BaseViewModel, TestViewModelType, TestViewModelInputs, TestViewModelOutputs {

    let disposeBag = DisposeBag()
    
    init(){
        super.init()
        
    }   

    var inputs: TestViewModelInputs { return self }
    var outputs: TestViewModelOutputs { return self }                                         

}