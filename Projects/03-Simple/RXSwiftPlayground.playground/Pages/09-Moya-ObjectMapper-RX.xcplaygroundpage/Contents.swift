//: [Previous](@previous)

import Foundation
import Moya
import ObjectMapper
import Moya_ObjectMapper
import RxSwift

import PlaygroundSupport

/*:
## `Moya`
เป็น Library ที่เขียนครอบ Alamofire ขึ้นมาอีกทีหนึ่ง
ทำให้เราสามารถประกาศ API เป็น Spec ได้
* ตัวอย่าง API Spec สำหรับยิงไป GitHub Service
*/

enum GithubService {
	case getUsers(offset: Int)
	case getRepos(username: String)
}

extension GithubService: TargetType {
	var baseURL: URL {
		return URL(string: "https://api.github.com")!
	}
	
	var path: String {
		switch self {
		case .getRepos(let username):
			return "/users/\(username)/repos"
		case .getUsers:
			return "/users"
		}
	}
	
	var method: Moya.Method {
		return .get
	}
	
	var parameters: [String: Any]? {
		switch self {
		case .getUsers(let offset):
			return [
				"since" : offset
			]
		case .getRepos(_):
			return nil
			
		}
	}
	
	// parameterEncoding มีให้เลือก URLEnconding และ JSONEncoding
	var parameterEncoding: ParameterEncoding {
		return URLEncoding.default
	}
	
	// sampleData สำหรับ stub (หรือ mockup)
	var sampleData: Data {
		switch self {
		case .getUsers:
			return "[{\"login\":\"mojombo\",\"id\":1,\"avatar_url\":\"https://avatars3.githubusercontent.com/u/1?v=3\",\"gravatar_id\":\"\",\"url\":\"https://api.github.com/users/mojombo\",\"html_url\":\"https://github.com/mojombo\",\"followers_url\":\"https://api.github.com/users/mojombo/followers\",\"following_url\":\"https://api.github.com/users/mojombo/following{/other_user}\",\"gists_url\":\"https://api.github.com/users/mojombo/gists{/gist_id}\",\"starred_url\":\"https://api.github.com/users/mojombo/starred{/owner}{/repo}\",\"subscriptions_url\":\"https://api.github.com/users/mojombo/subscriptions\",\"organizations_url\":\"https://api.github.com/users/mojombo/orgs\",\"repos_url\":\"https://api.github.com/users/mojombo/repos\",\"events_url\":\"https://api.github.com/users/mojombo/events{/privacy}\",\"received_events_url\":\"https://api.github.com/users/mojombo/received_events\",\"type\":\"User\",\"site_admin\":false}]".data(using: .utf8)!
		case .getRepos:
			return Data()
		}
	}
	
	// ประเภท Task มี request, download, upload
	var task: Task {
		return .request
	}
}


/*:
------
## `ObjectMapper`
เป็น Library ที่ใช้ Mapping JSON เป็น Object ที่เราสร้างไว้

* ตัวอย่าง Object Github User สำหรับ ObjectMapper
*/

class GitHubUser: Mappable {
	var login: String?
	var avatarURL: String?
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		login <- map["login"]
		avatarURL <- map["avatar_url"]
	}
}

/*:
------
## `Moya + ObjectMapper`
* ตัวอย่าง วิธีใช้งาน Moya คู่กับ Object Mapper

*/

//let provider = MoyaProvider<GithubService>()
let provider = MoyaProvider<GithubService>(stubClosure: MoyaProvider.delayedStub(0.2))

increseExecCount()
provider.request(.getUsers(offset: 0)) { (result) in
	switch result {
	case .success(let response):
		if let users = try? response.mapArray(GitHubUser.self) {
			print("Mapping success")
			print("Get user count \(users.count)")
		}else{
			//mapping fail
			print("Error mapping fail")
			print(String(data: response.data, encoding: .utf8)!)
		}
		break
	case .failure(let error):
		print(error.localizedDescription)
		break
	}
	
	popExecCount()
}

/*:
------

* ตัวอย่าง วิธีใช้งาน RxMoya คู่กับ Object Mapper แบบ

*/

let requestServiceTrigger = PublishSubject<Int>()

let onServiceRequest = requestServiceTrigger
	.do(onNext: { (_) in
		increseExecCount()
	})
	.flatMapLatest { (value) -> Observable<Int> in
		//let provider = RxMoyaProvider<GithubService>()
		let provider = RxMoyaProvider<GithubService>(stubClosure: RxMoyaProvider.delayedStub(0.2))
		
		return provider
			.request(
				.getUsers(offset: 0)
			)
			.mapArray(GitHubUser.self)
            .map {_ in return value }
		
	}

onServiceRequest.subscribe(onNext: { (response) in
	print("RX Get User Count: [\(response)]")
	popExecCount()
}, onError: { (error) in
	print("RX get Error: \(error.localizedDescription)")
	popExecCount()
})


requestServiceTrigger.onNext(0)

requestServiceTrigger.onNext(1)

requestServiceTrigger.onNext(2)

/*:
> สังเกตได้ว่า จะทำการ Call API ใหม่ทุกครั้งที่มีค่าใหม่มาที่ requestServiceTrigger
------------
> หากเราเปลี่ยนจาก flatMap เป็น flatMapLatest จะทำให้ Call API 3 รอบ แต่จะได้ Response กลับมารอบเดียว
  เนื่องจาก flatMapLatest จะทำการสร้าง Observable ตัวใหม่ขึ้นมาแทน
  แต่เราไม่ได้ subscribe ที่ Observable ตัวใหม่
  ทำให้เราไม่ได้รับค่าใหม่จาก API
*/

PlaygroundSupport.PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
