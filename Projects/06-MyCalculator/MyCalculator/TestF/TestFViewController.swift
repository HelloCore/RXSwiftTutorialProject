//
//  TestFViewController.swift
//  MyCalculator
//
//  Created by Nuntaporn on 8/21/2560 BE.
//  Copyright © 2560 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import UIKit

class TestFViewController: UIViewController {
    
    var input: Int = 6
    var result: Double = 0
    var index: [Double] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        input = 12
        
        
        for i in 0..<input+1 {
            var one: Double = 0
            var two: Double = 0
            if i == 0  {
                let sum = 0.0
                index.append(sum)
                result = sum
            } else if i == 1 {
                let sum = 1.0 + 0.0
                index.append(sum)
                result = sum
            } else if i == 2 {
                let sum = 1.0 + 0.0
                index.append(sum)
                result = sum
            } else if i > 2 {
                one = index[i-1]
                two = index[i-2]
                let sum = one + two
                index.append(sum)
                result = sum
            }
        }
        print(result)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
