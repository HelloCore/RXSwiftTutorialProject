import Foundation
import PlaygroundSupport

class PlaygroundUtil {
	static let shared = PlaygroundUtil()
	
	fileprivate var execCount = 0	
}

public func increseExecCount() {
	PlaygroundUtil.shared.execCount += 1
}

public func popExecCount() {
	PlaygroundUtil.shared.execCount -= 1
	if PlaygroundUtil.shared.execCount < 1 {
		PlaygroundPage.current.finishExecution()
	}
}
