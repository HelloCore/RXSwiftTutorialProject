//
//  BaseResponse.swift
//  LoginExample
//
//  Created by AKKHARAWAT CHAYAPIWAT on 6/24/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponse: Mappable {
	
	var status: String?
	var message: String?
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		status <- map["status"]
		message <- map["message"]
	}
	
}
