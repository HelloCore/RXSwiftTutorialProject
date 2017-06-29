//
//  BaseResponse.swift
//  LoginExample
//
//  Created by AKKHARAWAT CHAYAPIWAT on 6/24/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import Foundation
import ObjectMapper

enum ResponseStatus: String {
	case success = "success"
	case failure = "fail"
}

class BaseResponse: Mappable {
	
	var status: String?
	var message: String?
	
	var responseStatus: ResponseStatus {
		return ResponseStatus(rawValue: status ?? "")  ?? .failure
	}
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		status <- map["status"]
		message <- map["message"]
	}
	
}

extension Error {
	var json: [String: Any] {
		return [
			"status": ResponseStatus.failure.rawValue,
			"message": self.localizedDescription
		] as [String: Any]
	}
}
