//
//  LoginResponse.swift
//  LoginExample
//
//  Created by AKKHARAWAT CHAYAPIWAT on 6/24/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginResponse: BaseResponse {
	
	var name: String?
	
	required init?(map: Map) {
		super.init(map: map)
		
	}
	
	override func mapping(map: Map) {
		super.mapping(map: map)
		
		name <- map["name"]
	}
}
