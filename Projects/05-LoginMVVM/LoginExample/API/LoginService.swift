//
//  LoginService.swift
//  LoginExample
//
//  Created by AKKHARAWAT CHAYAPIWAT on 6/24/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import Foundation
import Moya

enum LoginService {
	case login(username: String, password: String)
}

extension LoginService: TargetType {
	var headers: [String : String]? {
		return nil
	}
	
	var baseURL: URL {
		// Dummy URL
		return URL(string: AppConstants.URL.baseURL)!
	}
	
	var path: String {
		return AppConstants.URL.loginPath
	}
	
	var method: Moya.Method {
		return .post
	}
	
	var sampleData: Data {
		switch self {
		case let .login(username, password):
			if username == "hellocore" && password == "anything" {
				return StubFile.loginSuccess.data
			}else{
				return StubFile.commonFailure.data
			}
		}
	}
	
	var task: Task {
		return .requestPlain
	}
}
