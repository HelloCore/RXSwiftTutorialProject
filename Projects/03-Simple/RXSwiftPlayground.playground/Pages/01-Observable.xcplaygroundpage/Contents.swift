//: Playground - noun: a place where people can play

import Foundation
import RxSwift

/*:
### `Observable`
Observable คือตัวแปรที่มี value เป็น Stream ซึ่งจะมีค่าส่งหรือไม่ส่งมาก็ได้

การที่จะเอาค่าออกมาใช้ได้ เราต้องทำการ Subscribe ไปที่ Observable

**สำคัญมาก หากรันไม่ได้ต้อง Compile Code ก่อน 1 ครั้ง (บน Simulator ก็ได้)**
*/

let firstStream = Observable<Int>.from([0,1,2,3,4,5,6,7,8,9,10])

firstStream
	.subscribe(onNext: { (value) in
		print("On next [\(value)]")
	}, onError: { (value) in
		print("On Error [\(value)]")
	}, onCompleted: {
		
	})


//: [Next](@next)
