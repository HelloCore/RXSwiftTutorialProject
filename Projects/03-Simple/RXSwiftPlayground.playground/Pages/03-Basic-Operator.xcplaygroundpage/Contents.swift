//: [Previous](@previous)

import UIKit
import RxSwift


let firstStream = Observable<Int>.from([0,1,2,3])

/*:
## `Map`
เป็น operator ที่ใช้แปลงค่าใน Stream

ตัวอย่าง แปลงจาก Int เป็น String
*/
print("---------------------[Example of Map]-----------------\n")

firstStream
	.map { (value) -> String in
		return "My Number is \(value)"
	}
	.subscribe(onNext: { (value) in
		print("On Next: [ \(value) ]")
	})

print("\n------------------------------------------------------")
/*:
------------------------------------------------------
## `Filter`
เป็น operator ที่ใช้กรองค่าตามเงื่อนไขที่กำหนด

ตัวอย่างการกรองค่าเฉพาะ value > 2
*/

print("-------------------[Example of Filter]----------------\n")
firstStream
	.filter { (value) -> Bool in
		return value > 2
	}
	.subscribe(onNext: { (value) in
		print("On Next: [\(value)]")
	})

print("\n------------------------------------------------------")
//: [Next](@next)
