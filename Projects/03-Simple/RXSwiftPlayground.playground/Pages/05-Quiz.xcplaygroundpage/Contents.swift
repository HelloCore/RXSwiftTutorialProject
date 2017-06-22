//: [Previous](@previous)

import Foundation
import UIKit
import RxCocoa
import RxSwift
import PlaygroundSupport


/*:
ให้จำลองการ Validate ค่าโดยมีเงื่อนไขคือ
	ถ้า length ของ username < 4
	จะทำการ Disable ปุ่ม Login

*** แก้ค่าใน function initialSubScription เท่านั้น

*** Step คือ 

Text 
-> Map เป็น Boolean
-> Bind ไปที่ Button RX IsEnabled

*** คำเตือน เมื่อเรียกใช้ฟังก์ชั่นเกี่ยวกับ RX ของ UI ให้ใช้ UI.RX ตลอด
**** เช่น TextField.text -> TextField.rx.text

*/


class MyViewController05: UIViewController {
	
	let disposeBag = DisposeBag()
	
	let textField = UITextField()
	let stackView = UIStackView()
	let button = UIButton(type: UIButtonType.roundedRect)
	
	func initialSubScription() {
        textField
            .rx
            .text
            .orEmpty
            .asObservable()
            .map { (username) -> Bool in
                return username.characters.count >= 4
            }
            .bind(to: button.rx.isEnabled)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		textField.borderStyle = .roundedRect
		textField.placeholder = "Username"
		button.setTitle("Login", for: .normal)
		
		stackView.axis = .vertical
		stackView.distribution = .fill
		
		stackView.addArrangedSubview(UIView())
		stackView.addArrangedSubview(textField)
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


let myVC = MyViewController05()

let (parent, _) = playgroundControllers(device: .phone4inch, orientation: .portrait, child: myVC)

PlaygroundPage.current.liveView = parent
//: [Next](@next)
