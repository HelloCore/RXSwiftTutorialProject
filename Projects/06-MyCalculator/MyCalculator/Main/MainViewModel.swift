//
//  MainViewModel.swift
//  MyCalculator
//
//  Created by Benz on 8/15/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import Foundation


protocol MainViewModelInputs {
	
}

protocol MainViewModelOutputs {
	
}

protocol MainViewModelType {
	var inputs: MainViewModelInputs { get }
	var outputs: MainViewModelOutputs { get }
}

class MainViewModel: MainViewModelType, MainViewModelInputs, MainViewModelOutputs {
	
	init() {
		
	}
	
	var inputs: MainViewModelInputs { return self }
	var outputs: MainViewModelOutputs { return self }
}
