//
//  CheckBrucketsViewController.swift
//  MyCalculator
//
//  Created by Nuntaporn on 8/21/2560 BE.
//  Copyright © 2560 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import UIKit

class CheckBrucketsViewController: UIViewController {

    @IBOutlet weak var inputsTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    var countInputs: Int = 0
    var textInputs: String = ""
    var isCheckResult: Bool = false
    
    let arrOpenOperator: [Character] = ["[","{","(","<"]
    let arrBackOperator: [Character] = ["]","}",")",">"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onOkTapped(_ sender: Any) {
        countInputs = (inputsTextField.text?.characters.count)!
        textInputs = inputsTextField.text!
        
        isCheckResult = checkOperator()
        
        if isCheckResult == true {
            resultLabel.text = "TRUE"
        } else {
            resultLabel.text = "FALSE"
        }
    }
    
    private func checkOperator() -> Bool {
        var inputsStack = Stack()
        for i in textInputs.characters {
            if arrOpenOperator.contains(i) {
                let index = arrOpenOperator.index(of: i)
                inputsStack.push((index?.description)!)
            } else if arrBackOperator.contains(i) {
                let index = arrBackOperator.index(of: i)
                if inputsStack.array.isEmpty || index?.description != inputsStack.pop() {
                    return false
                }
            } else {
                return false
            }
        }
        return true
    }
}

struct Stack {
    fileprivate var array: [String] = []
    
    mutating func push(_ element: String) {
        array.append(element)
    }
    
    mutating func pop() -> String? {
        return array.popLast()
    }
}
