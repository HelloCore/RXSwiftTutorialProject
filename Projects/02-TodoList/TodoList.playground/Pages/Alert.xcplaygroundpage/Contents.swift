//: [Previous](@previous)

import UIKit
import TodoFramework
import PlaygroundSupport

let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: AlertViewController.self))
let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
let navVC = UINavigationController.init(rootViewController: alertVC)
navVC.isNavigationBarHidden = true

let (parent, _) = playgroundControllers(device: .phone4_7inch, orientation: .portrait, child: navVC)
PlaygroundPage.current.liveView = parent
