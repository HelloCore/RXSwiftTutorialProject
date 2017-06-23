//: [Previous](@previous)

import Foundation
import RxSwift
import RxCocoa
import PlaygroundSupport

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "HH:mm:ss.SSS"

let pSubject = PublishSubject<String>()


/*:
## `flatMap`
เป็น operator ที่ใช้แปลงค่าใน Stream ให้กลายเป็น Observable ตัวใหม่
	โดยทุกครั้งที่มี Element ใหม่มา จะทำการ สร้าง Observable ใหม่ และทำการ **Merge** กับ Observable เก่า

## `flatMapLatest`
เป็น operator ที่ใช้แปลงค่าใน Stream ให้กลายเป็น Observable ตัวใหม่
	โดยทุกครั้งที่มี Element ใหม่มา จะทำการ สร้าง Observable ใหม่มา **​Replace** Observable เก่า

----
* ตัวอย่าง แปลงจาก Int เป็น Observable String
	ที่จะส่ง Element ออกมา 3 ครั้ง โดยมีระยะเวลาห่างกัน 1 วินาที

* ลอง แก้ comment ที่บรรทัด 35 และ 36 แล้วดูความแตกต่างสิ
*/

let conQueue = ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background)

let fObservable = pSubject
	.asObservable()
	.observeOn(conQueue)
//	.flatMapLatest { (value) -> Observable<String> in
	.flatMap { (value) -> Observable<String> in
		return Observable
			.create({ (observer) -> Disposable in
				// จำลอง sync async call
				increseExecCount()
				DispatchQueue.global().async {
					observer.onNext("\(value)] [1st time")
				}
				
				increseExecCount()
				DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: {
					observer.onNext("\(value)] [2nd time")
				})
				
				increseExecCount()
				DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2), execute: {
					observer.onNext("\(value)] [3rd time")
				})
				
				return Disposables.create()
			})
			.observeOn(conQueue)
}



let subscribe = fObservable
	.subscribe(onNext: { (result) in
//		print("\(dateFormatter.string(from: Date())) [\(result)] on \(Thread.current)")
		print("\(dateFormatter.string(from: Date())) [\(result)]")
		
		popExecCount()
	})


pSubject.onNext("❤️")

DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: {
	pSubject.onNext("💛")
})

DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2), execute: {
	pSubject.onNext("💚")
})


/*:
>	จะสังเกตได้ว่า fObservable จะได้รับค่าช้ากว่า pSubject 1 วินาที
	มักใช้ในกรณี Call Service หรือ Event ที่เป็น Async

![อธิบายเป็นภาพได้ตามนี้](FlatMapVSFlatMapLatest.png)
*/

PlaygroundSupport.PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
