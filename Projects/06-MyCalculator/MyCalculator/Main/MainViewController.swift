//
//  MainViewController.swift
//  MyCalculator
//
//  Created by Benz on 8/15/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {
	
	lazy var viewModel: MainViewModelType = {
		return MainViewModel()
	}()

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var equalBtn: UIButton!
    @IBOutlet weak var multiplyBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .outputs
            .resultForDisplay
            .drive(resultLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.outputs.isBtnEqualEnabled.drive(onNext: { (isEnabled) in
            self.equalBtn.isEnabled = isEnabled
            if isEnabled {
                self.equalBtn.backgroundColor = UIColor(red: (98/255), green: (87/255), blue: (114/255), alpha: 1.0)
            }else {
                self.equalBtn.backgroundColor = UIColor(red: (98/255), green: (87/255), blue: (114/255), alpha: 0.5)
            }
        }).addDisposableTo(disposeBag)
        
        viewModel
            .outputs
            .isBtnOperatorEnabled
            .drive(onNext: { (isEnabled) in
                let activeColor =  UIColor(red: (98/255), green: (87/255), blue: (114/255), alpha: 1.0)
                let inActiveColor = UIColor(red: (98/255), green: (87/255), blue: (114/255), alpha: 0.5)
                self.multiplyBtn.isEnabled = isEnabled
                self.minusBtn.isEnabled = isEnabled
                self.plusBtn.isEnabled = isEnabled
                if isEnabled {
                    self.multiplyBtn.backgroundColor = activeColor
                    self.minusBtn.backgroundColor = activeColor
                    self.plusBtn.backgroundColor = activeColor
                }else {
                    self.multiplyBtn.backgroundColor = inActiveColor
                    self.minusBtn.backgroundColor = inActiveColor
                    self.plusBtn.backgroundColor = inActiveColor

                }
            })
            .addDisposableTo(disposeBag)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func on1Tap(_ sender: Any) {
        viewModel.inputs.onNumberBtnTap("1")
    }
    
    @IBAction func on2Tap(_ sender: Any) {
        viewModel.inputs.onNumberBtnTap("2")
    }

    @IBAction func on3Tap(_ sender: Any) {
        viewModel.inputs.onNumberBtnTap("3")
    }
    
    @IBAction func on4Tap(_ sender: Any) {
        viewModel.inputs.onNumberBtnTap("4")
    }
    
    @IBAction func on5Tap(_ sender: Any) {
        viewModel.inputs.onNumberBtnTap("5")
    }
    @IBAction func on6Tap(_ sender: Any) {
        viewModel.inputs.onNumberBtnTap("6")
    }
    
    @IBAction func on7Tap(_ sender: Any) {
        viewModel.inputs.onNumberBtnTap("7")
    }
    
    @IBAction func on8Tap(_ sender: Any) {
        viewModel.inputs.onNumberBtnTap("8")
    }
    
    @IBAction func on9Tap(_ sender: Any) {
        viewModel.inputs.onNumberBtnTap("9")
    }
    
    @IBAction func on0Tap(_ sender: Any) {
        viewModel.inputs.onNumberBtnTap("0")
    }
    
    @IBAction func onMultiplyTap(_ sender: Any) {
        viewModel.inputs.onOperatorBtnTap(MyOperator.mutiply)
    }
    
    @IBAction func onMinusTap(_ sender: Any) {
        viewModel.inputs.onOperatorBtnTap(MyOperator.minus)
    }
    
    @IBAction func onPlusTap(_ sender: Any) {
        viewModel.inputs.onOperatorBtnTap(MyOperator.plus)
    }
    
    @IBAction func onClearTap(_ sender: Any) {
        viewModel.inputs.onClearBtnTap()
    }
    
    @IBAction func onEqualTap(_ sender: Any) {
        viewModel.inputs.onEqualBtnTap()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
