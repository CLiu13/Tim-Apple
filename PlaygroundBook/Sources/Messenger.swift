import Foundation
import PlaygroundSupport

public class Messenger {
    private var proxy: PlaygroundRemoteLiveViewProxy

    public init() {
        self.proxy = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy
    }

    public func sendPushApple() {
        self.sendMessage(name: "PushApple")
    }

    private func sendMessage(name: String) {
        let message: PlaygroundValue
        message = .dictionary(["Message": .string(name)])
        self.proxy.send(message)
    }
}
