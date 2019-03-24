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

    public func sendReset() {
        self.sendMessage(name: "Reset")
    }

    public func sendGetTallestBlock(index: Int) {
        self.sendMessage(name: "GetTallestBlock", payload: index)
    }

    public func sendMoveTallestToFront(index: Int) {
        self.sendMessage(name: "MoveTallestToFront", payload: index)
    }

    private func sendMessage(name: String) {
        let message: PlaygroundValue
        message = .dictionary(["Message": .string(name)])
        self.proxy.send(message)
    }

    private func sendMessage(name: String, payload: Int) {
        let message: PlaygroundValue
        message = .dictionary(["Message": .string(name), "Payload": .integer(payload)])
        self.proxy.send(message)
    }
}
