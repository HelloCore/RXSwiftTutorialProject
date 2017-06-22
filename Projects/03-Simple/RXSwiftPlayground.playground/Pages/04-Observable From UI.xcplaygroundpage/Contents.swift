//: [Previous](@previous)

import Foundation
import UIKit
import RxCocoa
import RxSwift
import PlaygroundSupport

/*:
เราสามารถใช้ property .rx เพื่อดึง Observable จาก UI ได้
*/

class MyViewController: UIViewController {
	
	let disposeBag = DisposeBag()
	
	let textField = UITextField()
	let textField2 = UITextField()
	let stackView = UIStackView()
	let button = UIButton(type: UIButtonType.roundedRect)
	
	
	func initialSubScription() {
		// Subscribe ด้วย text
		textField
			.rx //** <--- สำคัญมาก
			.text
			.orEmpty
			.asObservable()
			.subscribe(onNext: { (str) in
				print("TextField1 str: [\(str)]")
			})
			.addDisposableTo(disposeBag)
		
		// Bind ค่า TextField2 ไปที่ TextField1
		textField2
			.rx //** <--- สำคัญมาก
			.text
			.orEmpty
			.asObservable()
			.do(onNext: { (str) in
				/* 
					Function DO จะทำงานเมื่อมี Event ผ่านเข้ามาใน Stream นี้
					แต่จะไม่สามารถแก้ไขค่าอะไรได้
				*/
				print("TextField2 str: [\(str)]")
			})
			.bind(to: textField.rx.text)
			.addDisposableTo(disposeBag)
		
		button
			.rx //** <--- สำคัญมาก
			.tap
			.subscribe(onNext: { (value) in
				/*
				Button จะส่งค่ามาเป็น Void คือ () เท่านั้น
				*/
				print("Button always emit Void [ \(value) ]")
			})
			.addDisposableTo(disposeBag)
		
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		textField.borderStyle = .roundedRect
		textField.placeholder = "TextField1"
		
		textField2.borderStyle = .roundedRect
		textField2.placeholder = "TextField2"
		
		button.setTitle("Button", for: .normal)
		
		stackView.axis = .vertical
		stackView.distribution = .fill
		
		stackView.addArrangedSubview(UIView())
		stackView.addArrangedSubview(textField)
		stackView.addArrangedSubview(textField2)
		stackView.addArrangedSubview(button)
		stackView.addArrangedSubview(UIView())
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(stackView)
		
		NSLayoutConstraint.activate([
				stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
				stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
				stackView.topAnchor.constraint(equalTo: self.view.topAnchor),
				stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
			])
		self.initialSubScription()
	}
}


let myVC = MyViewController()

let (parent, _) = playgroundControllers(device: .phone4inch, orientation: .portrait, child: myVC)

PlaygroundPage.current.liveView = parent

//: [Next](@next)
