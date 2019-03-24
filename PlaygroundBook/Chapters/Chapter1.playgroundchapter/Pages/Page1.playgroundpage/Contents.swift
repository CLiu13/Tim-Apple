/*:
 ![Tim Apple 🍎](icon.png)

 # Overview
 Help Tim regain his apple by **sorting** the blocks so the apple can fall back down!
 What exactly is **sorting**? Well, you probably do it on a regular basis - whether you are arranging your school papers by date, cleaning up your messy sock drawer based on color, or being assigned to your Hogwarts house by a talking hat, you are **sorting**!

 # Instructions
 Let's start off simple. Use your finger to drag the blue blocks around the screen. Your goal is to get them in a descending order - that is, from tallest to shortest. That way, our apple has a path to roll down on!

 Once you do that, type a direction into the `pushApple()` function below. You can choose between **"left"**, **"right"**, **"up"**, or **"down"** (don't forget the quotes, they are strings). Think carefully! Aftewards, hit the *Run My Code* button.

 If you get stuck, don't give up - try your best, and some helpful hints will guide you along the way!

 Best of luck, and get going! Tim needs his apple back!
 
 */
//#-hidden-code
import UIKit
import PlaygroundSupport

class Listener: PlaygroundRemoteLiveViewProxyDelegate {
    func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        PlaygroundPage.current.assessmentStatus = .pass(message: "Nicely done! However, what if there were more blocks to sort? [Move on!](@next)")
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
 Nicely done! However, what if there were more blocks to sort? [Move on!](@next)
 */
