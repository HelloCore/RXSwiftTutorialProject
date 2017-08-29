//
//  BinarySearchViewController.swift
//  MyCalculator
//
//  Created by Nuntaporn on 8/22/2560 BE.
//  Copyright © 2560 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import UIKit

class BinarySearchViewController: UIViewController {

//    var arrRawData = [50,130,4,145,13,8,1,120,3,5,12,17,32,19,30]
    var arrData: [Int] = []
    var middle = 0
    var inputsNumber = 1
    var isCheckResult: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isCheckResult = binarySearch()
        print(isCheckResult)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func binarySearch() -> Bool {
        var arrRawData = [Int]()
        for x in 0...1000000{
            arrRawData.append(x)
        }
        print("mmmmm")
        var isCheckNumber: Bool = false
//        print("Raw Data \(arrRawData)")
//        print("------------------------")
        arrData = arrRawData.sorted()
//        print("Sorted Data \(arrData)")
//        print("------------------------")
        for _ in arrData {
            if !arrData.contains(inputsNumber) {
                return false
            } else {
                let middleIndex = arrData.index(arrData.startIndex, offsetBy: (arrData.count/2))
                middle = arrData[middleIndex]
//                print("Middle = \(middle)")
                if inputsNumber > middle {
                    arrData = Array(arrData.dropFirst(middleIndex))
//                    print("\(arrData)")
                    isCheckNumber = false
                } else if inputsNumber < middle {
                    arrData = Array(arrData.dropLast(middleIndex))
//                    print("\(arrData)")
                    isCheckNumber = false
                } else if inputsNumber == middle {
                    return true
                }
            }
        }
        return isCheckNumber
    }
    
    static func findBinarySearch(number: Int) -> Int {
        var arrChoice = [Int]()
        for x in 1...1000000 {
            arrChoice.append(x)
        }
        print("arr fin")
        arrChoice = arrChoice.reversed()
        arrChoice = arrChoice.sorted()
        var leftIndex = 0
        var rightIndex = arrChoice.count - 1
        repeat {
            let middleIndex =  Int((rightIndex + leftIndex) / 2)
            
            if arrChoice[middleIndex] == number {
                return middleIndex
            }else if arrChoice[middleIndex] < number {
                leftIndex = (middleIndex + 1)
            }else{
                rightIndex = (middleIndex - 1)
            }
        } while (rightIndex - leftIndex) > 1
        
        if arrChoice[rightIndex] == number{
            return rightIndex
        }else if arrChoice[leftIndex] == number{
            return leftIndex
        }
        return -1
    }

}
