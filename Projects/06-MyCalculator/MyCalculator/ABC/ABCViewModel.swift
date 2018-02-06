//
//  ABCViewModel.swift
//  MyCalculator
//
//  Created by Benz on 9/12/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ABCViewModelInputs {

}

protocol ABCViewModelOutputs {

}

protocol ABCViewModelType {
    var inputs: ABCViewModelInputs { get }
    var outputs: ABCViewModelOutputs { get }
}

class ABCViewModel: BaseViewModel, ABCViewModelType, ABCViewModelInputs, ABCViewModelOutputs {

    let disposeBag = DisposeBag()
    
    init(){
        super.init()
        
    }   

    var inputs: ABCViewModelInputs { return self }
    var outputs: ABCViewModelOutputs { return self }                                         

}