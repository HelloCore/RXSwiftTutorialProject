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
	
	/// The parameters to be encoded in the request.
	var parameters: [String: Any]? {
		switch self {
		case .getUser(let offset):
			return [ "since": offset ]
		}
	}
	
	/// The method used for parameter encoding.
	var parameterEncoding: ParameterEncoding {
		return URLEncoding.default
	}
	
	/// Provides stub data for use in testing.
	var sampleData: Data {
		return Data()
	}
	
	/// The type of HTTP task to be performed.
	var task: Task {
		return .request
	}

}

