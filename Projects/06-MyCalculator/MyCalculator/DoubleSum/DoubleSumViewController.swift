//
//  DoubleSumViewController.swift
//  MyCalculator
//
//  Created by Nuntaporn on 8/22/2560 BE.
//  Copyright © 2560 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import UIKit

class DoubleSumViewController: UIViewController {

    var isCheckFinish = false
    var totalSummary = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        isCheckFinish = doubleSum(inputs: 20)
//        print(isCheckFinish)
//        totalSummary = doubleSumIndex(inputs: 10)
        totalSummary = tripleSumIndex(inputs: 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func doubleSum(inputs: Int) -> Bool {
//        var arrRawData = [Int]()
//        for number in 0...1000{
//            arrRawData.append(number)
//        }
        
        var arrRawData = [50,130,4,145,13,8,1,120,3,5,12,17,32,19,30]
        arrRawData.sort()
        print(arrRawData)
        
        var firstIndex = 0
        var secondIndex = 0
        
        for _ in arrRawData {
            let randomIndex = Int(arc4random_uniform(UInt32(arrRawData.count)))
            let firstNum = arrRawData[randomIndex]
            if inputs > firstNum {
                firstIndex = randomIndex
                let secondNum = inputs - firstNum
                if arrRawData.contains(secondNum) {
                    secondIndex = arrRawData.index(of: secondNum)!
                    print(firstIndex)
                    print(secondIndex)
                    return true
                }
            }
        }
        return false
    }
    
    private func doubleSumIndex(inputs: Int) -> Int {
        var arrRawData = [50,130,4,145,13,8,1,120,3,5,12,17,32,19,30]
        
        arrRawData = arrRawData.reversed()
        arrRawData = arrRawData.sorted()
        print(arrRawData)
        
        var leftIndex = 0
        var rightIndex = arrRawData.count - 1
        
        repeat {
            let sum =  arrRawData[leftIndex] + arrRawData[rightIndex]
            
            if sum == inputs {
                print(leftIndex)
                print(rightIndex)
                return sum
            } else if sum < inputs {
                leftIndex += 1
            }else{
                rightIndex -= 1
            }
        } while leftIndex < rightIndex
        print("Fail")
        return -1
    }
    
    private func tripleSumIndex(inputs: Int) -> Int {
        var arrRawData = [50,130,4,145,13,8,1,120,3,5,12,17,32,19,30]
        
        arrRawData = arrRawData.reversed()
        arrRawData = arrRawData.sorted()
        print(arrRawData)
        
        var leftIndex = 0
        var rightIndex = arrRawData.count - 1
        var middleIndex = 0
        
        repeat {
            middleIndex =  Int((rightIndex + leftIndex) / 2)
            let sum =  arrRawData[leftIndex] + arrRawData[rightIndex] + arrRawData[middleIndex]
            
            if sum == inputs {
                print(leftIndex)
                print(middleIndex)
                print(rightIndex)
                return sum
            } else if sum < inputs {
                leftIndex += 1
            }else{
                rightIndex -= 1
            }
        } while leftIndex < middleIndex || middleIndex < rightIndex
        print("Fail")
        return -1
    }
    
}
