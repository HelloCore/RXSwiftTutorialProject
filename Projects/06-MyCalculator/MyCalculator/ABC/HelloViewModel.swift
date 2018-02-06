//
//  HelloViewModel.swift
//  MyCalculator
//
//  Created by Benz on 9/12/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HelloViewModelInputs {

}

protocol HelloViewModelOutputs {

}

protocol HelloViewModelType {
    var inputs: HelloViewModelInputs { get }
    var outputs: HelloViewModelOutputs { get }
}

class HelloViewModel: BaseViewModel, HelloViewModelType, HelloViewModelInputs, HelloViewModelOutputs {

    let disposeBag = DisposeBag()
    
    init(){
        super.init()
        
    }   

    var inputs: HelloViewModelInputs { return self }
    var outputs: HelloViewModelOutputs { return self }                                         

}