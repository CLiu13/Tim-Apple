/*:
 ![Tim Apple 🍎](icon.png)

 # Instructions
 Awesome! If you are reading this, that means that you are almost finished with learning the basics about sorting. Hooray! 🎉

 Now, let's try one more sorting algorithm. This time, we will be using **insertion sort**. It is fairly similar to selection sort in terms of simplicity and efficiency, but it does use a different approach.

 In a nutshell, **insertion sort** works by building a sorted list of objects one-at-a-time.

 Again, refer to GitHub user *raywenderlich* wonderful guide on **insertion sort** for Swift, which can be found [here](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Insertion%20Sort).

 Like before, our **insertion sort** algorithm is based on *raywenderlich*'s. In fact, this time, both of our algorithms are in ascending order. Keep that in mind as you work through the rest of this challenge.

 And of course, here are two methods that will help you tremendously with the sorting: `getCurrentBlock(index: Int)` and `moveBlockUntilFit()` (note the lack of a parameter). There is also the `reset()` method, just in case.

 Good luck! Hints are provided as always, and feel free to take a peak at the solution if you want.
 */
//#-hidden-code
import UIKit
import PlaygroundSupport

class Listener: PlaygroundRemoteLiveViewProxyDelegate {
    func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        PlaygroundPage.current.assessmentStatus = .pass(message: "Bravo! You are now a master of sorting!")
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
func insertionSort() {
    let count = 10
    for i in 1..<count {
        getCurrentBlock(index: i)
        moveBlockUntilFit()
    }
}

insertionSort()
pushApple(direction: "left")
"""

func getCurrentBlock(index: Int) {
    messenger.sendGetCurrentBlock(index: index)
}

func moveBlockUntilFit() {
    messenger.sendMoveBlockUntilFit()
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
    } else if (direction == "right") {
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["Hmm, the apple will bump into the wall. Try again! (Gotcha there, didn't I?)"], solution: solution)
        PlaygroundPage.current.finishExecution()
    } else if (direction == "left") {
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
func insertionSort() {
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

insertionSort()
pushApple(direction: /*#-editable-code*/<#T##direction##String#>/*#-end-editable-code*/)
/*:
 # Congrats! 🎉
 Bravo! You are now a master of the basics of sorting! Even better, Tim is finally reunited with his apple! (Hopefullly he doesn't lose it again.)

 # Learn More
 Eager to learn more? Check out some of Apple's templates, which can be found in the Swift Playgrounds iPad app! I strongly recommend the *Learn to Code* series by Apple - which suprisingly doesn't cover sorting - but serves as a strong foundation for anyone looking to use Swift.

 # Acknowledgements
 Special thanks to the team at Apple who developed the Shapes template, which made this project possible.
 Most importantly, thank YOU for reviewing my WWDC19 submission! My fingers are crossed 🤞
 */
