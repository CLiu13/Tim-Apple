/*:
 ![Tim Apple 🍎](icon.png)

 # Instructions
 Good work! It should have taken you a bit longer to complete the last challenge, since there were more blocks. Or, perhaps you got lucky, and the blocks were already arranged in a semi-sorted manner. Regardless though, as the number of objects that you are sorting increases, the time that it takes to sort those objects, on average, increases as well. That means that if you were sorting 100 blocks by hand, it would take quite a while.

 That is where the computer comes in! It can definitely sort much faster than you or me. However, in order to get it to do what we want, we need to provide it with some code to execute.

 That is your current task - to write the code needed to have the computer sort a series of blocks. Specifically, you will be using a **selection sort** algorithm, which is one of the easier ones.

 What exactly is **selection sort**? Well, in a nutshell, it sorts by always finding the smallest (or biggest, if descending order) value and placing it at the beginning.

 Start off by exmaning a **selection sort** algorithm written in Swift by GitHub user *raywenderlich*, which can be found [here](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Selection%20Sort). There is an excellent, detailed explanation about the algorithm, and he provides you with the code for it.

 Our **selection sort** algorithm is based on *raywenderlich*'s, but his is in ascending order (smallest to greatest) while ours is in descending order (greatest to smallest). To help out, I have written two functions for you to use that take care of a large chunk of the sorting: `getTallestBlock(index: Int)` and `moveTallestToFront(index: Int)`. There is also a `reset()` method, just in case.

 Good luck! Don't forget to determine the push direction at the end. And if you do get stuck, look out for those helpful hints. If you really need it, you can also check out the complete solution.

 */
//#-hidden-code
import UIKit
import PlaygroundSupport

class Listener: PlaygroundRemoteLiveViewProxyDelegate {
    func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        PlaygroundPage.current.assessmentStatus = .pass(message: "Awesome work! Let's explore another sorting algorithm, but with a twist this time. [Move on!](@next)")
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
let solution = """
func selectionSort() {
    let count = 10
    for i in 0..<(count - 1) {
        getTallestBlock(index: i)
        moveTallestToFront(index: i)
    }
}

selectionSort()
pushApple(direction: "right")
"""

func getTallestBlock(index: Int) {
    messenger.sendGetTallestBlock(index: index)
}

func moveTallestToFront(index: Int) {
    messenger.sendMoveTallestToFront(index: index)
}

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
func selectionSort() {
    // The number of objects to sort
    let count = /*#-editable-code*/<#T##count##Int#>/*#-end-editable-code*/
    for i in /*#-editable-code*/<#T##start##Int#>/*#-end-editable-code*/..</*#-editable-code*/<#T##end##Int#>/*#-end-editable-code*/ {
        //#-editable-code

        //#-end-editable-code
        //#-hidden-code
        sleep(1)
        //#-end-hidden-code
    }
}

selectionSort()
pushApple(direction: /*#-editable-code*/<#T##direction##String#>/*#-end-editable-code*/)
/*:
 Awesome work! Let's explore another sorting algorithm, but with a twist this time. [Move on!](@next)
 */
