//: [Previous](@previous)

import Foundation
import RxSwift

let subject1 = BehaviorSubject<Int>(value: 0)
let subject2 = BehaviorSubject<Int>(value: 100)


/*:
## `Merge`
เป็น Operator ที่ใช้รวมค่าใน Stream

เมื่อมีค่ามาใน Stream ใด Stream หนึ่ง ค่านั้นจะถูกส่งมาที่ Observable ที่ได้จาก Operator นี้ด้วย

*/
print("---------------------[Example of Merge]-----------------\n")

let mergedStream = Observable.merge([
		subject1.asObserver(),
		subject2.asObserver()
	])

let mergeSubscribe = mergedStream.subscribe(onNext: { (value) in
	print("mergeSubscribe onNext: [\(value)]")
})

subject1.onNext(1)
subject1.onNext(2)

subject2.onNext(50)
subject2.onNext(60)

subject1.onNext(3)

mergeSubscribe.dispose()

print("\n------------------------------------------------------")

/*:

-----------------------------------------------

## `CombineLastest`
เป็น Operator ที่ใช้รวมค่าสุดท้ายของ Stream

เมื่อมีค่ามาใน Stream ใด Stream หนึ่ง ค่านั้นจะถูกส่งมาใน Observable ใหม่ พร้อมกับค่าจาก Stream อื่นด้วย

*/

// clear ค่าเก่า
subject1.onNext(0)
subject2.onNext(100)


print("--------------[Example of Combine Latest]-------------\n")

let combineStream = Observable.combineLatest(
		subject1.asObservable(),
		subject2.asObservable()
) { (sub1, sub2) -> (subject1: Int, subject2: Int) in
	return (subject1: sub1, subject2: sub2)
}

let combineSubscribe = combineStream.subscribe( onNext: { (value) in
		print("value subject1:\(value.subject1) subject2:\(value.subject2)")
	})


subject2.onNext(99)
subject2.onNext(98)
subject1.onNext(1)
subject2.onNext(97)
subject2.onNext(96)
subject1.onNext(2)

combineSubscribe.dispose()

print("\n------------------------------------------------------")

//: [Next](@next)
