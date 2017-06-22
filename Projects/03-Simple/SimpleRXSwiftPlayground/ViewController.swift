//
//  ViewController.swift
//  SimpleRXSwiftPlayground
//
//  Created by AKKHARAWAT CHAYAPIWAT on 6/22/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yy HH:mm:ss.SSS"
		
		let pSubject = PublishSubject<String>()
		let conQueue = ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background)
		
		let fObservable = pSubject
			.asObservable()
//			.do(onNext: { (value) in
//				print("\(dateFormatter.string(from: Date())) pSubject receive [\(value)] on \(Thread.current)")
//			})
			.observeOn(conQueue)
			.flatMap { (value) -> Observable<String> in
				return Observable
					.create({ (observer) -> Disposable in
						// จำลอง sync async call
						DispatchQueue.global().async {
							observer.onNext("\(value)] [1st time")
						}
						
						DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: {
							observer.onNext("\(value)] [2nd time")
						})
						
						DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2), execute: {
							observer.onNext("\(value)] [3rd time")
						})
						
						return Disposables.create()
					})
					.observeOn(conQueue)
		}
		
		
		
		let subscribe = fObservable
			.subscribe(onNext: { (result) in
				print("\(dateFormatter.string(from: Date())) [\(result)] on \(Thread.current)")
				print("---------------------")
			})
		
		
		pSubject.onNext("❤️")
		
		DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: {
			pSubject.onNext("💛")
		})
		
		DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2), execute: {
			pSubject.onNext("💚")
		})

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

