//: [Previous](@previous)

import Foundation

import RxSwift
import PlaygroundSupport

let disposeBag = DisposeBag()
//: [Next](@next)

let coldObservable = Observable<Int>.create { (source) -> Disposable in
	
	increseExecCount()
	increseExecCount()
	increseExecCount()
	increseExecCount()
	
	source.onNext(1)
	
	DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100), execute: {
		source.onNext(2)
	})
	
	DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(200), execute: {
		source.onNext(3)
	})
	
	DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(300), execute: {
		source.onNext(4)
	})
	
	return Disposables.create()
}


coldObservable.subscribe(onNext: { (value) in
	print("coldObservable1: \(value)")
	popExecCount()
}).addDisposableTo(disposeBag)

coldObservable.subscribe(onNext: { (value) in
	print("coldObservable2: \(value)")
	popExecCount()
}).addDisposableTo(disposeBag)

PlaygroundSupport.PlaygroundPage.current.needsIndefiniteExecution = true

