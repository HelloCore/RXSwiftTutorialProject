//: [Previous](@previous)

import Foundation
import RxSwift

/*:
### `Subject`
เป็นได้ทั้ง `Observable`, `Observer` และสามารถส่ง Value ด้วยตัวเราเองได้
หลักๆมี Variable, Published Subject, Behavior Subject, และ Replay Subject


-------------------------------------------------
##### `Behavior Subject`
เป็น Subject ที่จะเก็บค่าสุดท้ายไว้เสมอ
*/
print("---------[Example of Behavior Subject]----------\n")

let bSubject = BehaviorSubject(value: 0)

let subscribe1 = bSubject.subscribe(onNext: { (value) in
		print("bSubscribe1 onNext [\(value)]")
	}, onError: { (error) in
		print("bSubscribe1 onError [\(error)]")
	})

bSubject.onNext(1)

let subscribe2 = bSubject.subscribe(onNext: { (value) in
	print("bSubscribe2 onNext [\(value)]")
}, onError: { (error) in
	print("bSubscribe2 onError [\(error)]")
})

bSubject.onNext(2)

subscribe1.dispose()
subscribe2.dispose()

print("\n------------------------------------------------")

/*:
จากตัวอย่างด้านบน สังเกตได้ว่า bSubscribe2 เริ่ม Subscribe หลังจาก bSubject ส่งค่าใหม่มาแล้ว 
ทำให้ bSubscribe2 ไม่ได้รับค่าแรก (0)

-------------------------------------------------
##### `Variable`
เป็น Subject ที่เก็บค่าสุดท้ายไว้เหมือนกับ BehaviorSubject 
แต่จะต่างกันตรงที่ Variable จะไม่มี Event OnError
และ Variable ถูกสร้างมาให้ใช้งานง่าย เหมาะสำหรับมือใหม่
*/
print("-------------[Example of Variable]--------------\n")

let vSubject = Variable<Int>(0)

let vSubscribe = vSubject.asObservable()
	.subscribe(onNext: { (value) in
		print("vSubscribe onNext [\(value)]")
	})


vSubject.value = 1
vSubject.value = 2
vSubject.value = 2

vSubscribe.dispose()
print("\n-------------------------------------------------")

/*:
จากตัวอย่างด้านบน สังเกตได้ว่า แม้ว่าเราจะ Set Value เป็นค่าซ้ำ
ตัวมันก็จะส่งค่านั้นไปให้ Observer อยู่ดี

-------------------------------------------------
##### `Published Subject`
เป็น Subject ที่ไม่เก็บค่าใดเลย
หมายความว่าจะมีเฉพาะ Observer ที่ Subscribe ตัวมันเท่านั้น ที่จะได้รับค่าไป
*/

print("-----------[Example of PublishSubject]-----------\n")

let pSubject = PublishSubject<Int>()

pSubject.onNext(0)

let pSubscribe1 = pSubject.asObserver()
	.subscribe(onNext: { (value) in
		print("pSubscribe1 onNext [\(value)]")
	})

pSubject.onNext(1)

let pSubscribe2 = pSubject.asObserver()
	.subscribe(onNext: { (value) in
		print("pSubscribe2 onNext [\(value)]")
	})

pSubject.onNext(2)

print("\n-------------------------------------------------")

/*:
จากตัวอย่างด้านบน สังเกตได้ว่า pSubscribe1 จะไม่ได้รับค่า 0 เนื่องจาก
ณ เวลาที่ pSubject ส่งค่า 0 ไป ตัว pSubscribe1 ยังไม่ได้ทำการ subscribe

*/
//: [Next](@next)
