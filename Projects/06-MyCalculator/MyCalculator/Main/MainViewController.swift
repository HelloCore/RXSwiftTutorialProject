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
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.outputs.resultForDisplay.drive(resultLabel.rx.text).addDisposableTo(disposeBag)
        
        

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
