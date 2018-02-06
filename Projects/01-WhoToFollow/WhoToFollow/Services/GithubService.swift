//
//  GithubService.swift
//  WhoToFollow
//
//  Created by AKKHARAWAT CHAYAPIWAT on 6/20/17.
//  Copyright © 2017 AKKHARAWAT CHAYAPIWAT. All rights reserved.
//

import Foundation
import Moya

enum GithubService {
	
	case getUser(offset: Int)
	
}

extension GithubService: TargetType {
	
	var headers: [String : String]? {
		return nil
	}
	
	/// The target's base `URL`.
	var baseURL: URL {
		return URL(string: "https://api.github.com/")!
	}
	
	/// The path to be appended to `baseURL` to form the full `URL`.
	var path: String {
		return "users"
	}
	
	/// The HTTP method used in the request.
	var method: Moya.Method {
		return .get
	}
	
	/// Provides stub data for use in testing.
	var sampleData: Data {
		return Data()
	}
	
	/// The type of HTTP task to be performed.
	var task: Task {
		switch self {
		case .getUser(let offset):
			return .requestParameters(parameters: ["since": offset], encoding: URLEncoding.default)
		}
	}

}

