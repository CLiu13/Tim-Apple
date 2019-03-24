import UIKit
import PlaygroundSupport

class Listener: PlaygroundRemoteLiveViewProxyDelegate {
    func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        PlaygroundPage.current.assessmentStatus = .pass(message: "Nicely done! Let's move on. [Next](@next)")
        PlaygroundPage.current.finishExecution()
    }
    func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {
    }
}

let listener = Listener()
if let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy {
    proxy.delegate = listener
}

let messenger = Messenger()
let solution = "`pushApple(\"right\")`"

func pushApple(direction: String) {
    if (direction == "up") {
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["Uh oh, the apple can't defy gravity. Try again!"], solution: solution)
    } else if (direction == "down") {
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["Hmm, gravity already does that for us. Try again!"], solution: solution)
    } else if (direction == "left") {
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["Ouch, the apple will bump into the wall. Try again!"], solution: solution)
    } else if (direction == "right") {
        messenger.sendPushApple()

        PlaygroundPage.current.needsIndefiniteExecution = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            PlaygroundPage.current.finishExecution()
        }
    } else {
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["That's not a valid direction, try again!"], solution: solution)
    }
}

pushApple(direction: <#T##direction##String#>)
