//: [Previous](@previous)

import UIKit
import RxSwift


let myStream = BehaviorSubject<Int>(value: 0)

/*:
## `Map`
เป็น operator ที่ใช้แปลงค่าใน Stream

ตัวอย่าง แปลงจาก Int เป็น String
*/
print("---------------------[Example of Map]-----------------\n")


let mapSubscribe = myStream
	.map { (value) -> String in
		// Change Int to String
		return "My Number is \(value)"
	}
	.subscribe(onNext: { (value) in
		print("On Next: [ \(value) ]")
	})

myStream.onNext(1)
myStream.onNext(2)

print("\n------------------------------------------------------")

mapSubscribe.dispose()
/*:
------------------------------------------------------
## `Filter`
เป็น operator ที่ใช้กรองค่าตามเงื่อนไขที่กำหนด

ตัวอย่างการกรองค่าเฉพาะ value > 2
*/

myStream.onNext(0)

print("-------------------[Example of Filter]----------------\n")

let filterSubScribe = myStream
	.filter { (value) -> Bool in
		// ทำงานต่อเฉพาะค่าที่มากกว่า 2
		return value > 2
	}
	.map { (value) -> String in
		// Change Int to String
		return "My Number is \(value)"
	}
	.subscribe(onNext: { (value) in
		print("On Next: [\(value)]")
	})

myStream.onNext(1)
myStream.onNext(2)
myStream.onNext(3)
myStream.onNext(4)

print("\n------------------------------------------------------")

filterSubScribe.dispose()

myStream.onNext(0)

/*:
------------------------------------------------------
## `Merge`

*/
myStream.onNext(0)

print("-------------------[Example of Merge]----------------\n")

let secondStream = BehaviorSubject<Int>(value: 100)

let mergedSubscribe = Observable.merge([
		myStream.asObserver(),
		secondStream.asObserver()
	]).subscribe(onNext: { (value) in
		print("On Next: [\(value)]")
	})

myStream.onNext(1)
secondStream.onNext(99)
secondStream.onNext(98)
secondStream.onNext(97)
myStream.onNext(2)
myStream.onNext(3)


print("\n------------------------------------------------------")

mergedSubscribe.dispose()



/*:
------------------------------------------------------
## `CombineLatest`

*/

myStream.onNext(0)

print("----------------[Example of CombineLatest]------------\n")

let messageStream = BehaviorSubject<String>(value: "A")

let combineSubscribe = Observable.combineLatest(myStream, messageStream) { (valueOfMyStream, valueOfMessageStream) -> String in
		return " MyStream \(valueOfMyStream) MessageStream \(valueOfMessageStream) "
	}
	.subscribe(onNext: { (value) in
		print("On Next: [\(value)]")
	})

messageStream.onNext("BB")
myStream.onNext(1)
myStream.onNext(2)
myStream.onNext(3)
messageStream.onNext("CC")
myStream.onNext(4)

print("\n------------------------------------------------------")

combineSubscribe.dispose()

//: [Next](@next)