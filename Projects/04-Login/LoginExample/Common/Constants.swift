//
//  Constants.swift
//  LoginExample
//
//  Created by AKKHARAWAT CHAYAPIWAT on 6/24/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import Foundation


struct AppConstants {
	struct URL {
		// dummy URL
		static let baseURL = "https://www.google.com/"
		static let loginPath = "login"
	}
}

class DummyClass {
	
}

enum StubFile: String {
	
	case commonFailure = "failure"
	case loginSuccess = "success"
	
	var data: Data {
		let bundle = Bundle(for: DummyClass.self)
		let path = bundle.path(forResource: self.rawValue, ofType: "json")
		return (try? Data(contentsOf: URL(fileURLWithPath: path!))) ?? Data()
	}
	
}


