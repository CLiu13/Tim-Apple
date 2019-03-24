//#-hidden-code
import UIKit
import PlaygroundSupport

class Listener: PlaygroundRemoteLiveViewProxyDelegate {
    func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        PlaygroundPage.current.assessmentStatus = .pass(message: "Great job! That took a little longer, right? What if we could have the computer do the sorting for us? [Move on!](@next)")
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
let solution = "First, drag the blocks into descending order by height. Then, use `pushApple(\"right\")`."

func reset() {
    messenger.sendReset()
}

func pushApple(direction: String) {
    if (direction == "up") {
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["Hmm, the apple can't defy gravity. Try again!"], solution: solution)
        PlaygroundPage.current.finishExecution()
    } else if (direction == "down") {
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["Hmm, gravity already does that for us. Try again!"], solution: solution)
        PlaygroundPage.current.finishExecution()
    } else if (direction == "left") {
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["Hmm, the apple will bump into the wall. Try again!"], solution: solution)
        PlaygroundPage.current.finishExecution()
    } else if (direction == "right") {
        messenger.sendPushApple()

        PlaygroundPage.current.needsIndefiniteExecution = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            PlaygroundPage.current.assessmentStatus = .fail(hints: ["Hmm, the apple didn't reach Tim. Try again!"], solution: solution)
            PlaygroundPage.current.finishExecution()
        }
    } else {
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["That's not a valid direction, try again!"], solution: solution)
        PlaygroundPage.current.finishExecution()
    }
}
//#-end-hidden-code
//#-code-completion(everything, hide)
pushApple(direction: /*#-editable-code*/<#T##direction##String#>/*#-end-editable-code*/)
/*:
 Great job! That took a little longer, right? What if we could have the computer do the sorting for us? [Move on!](@next)
 */
