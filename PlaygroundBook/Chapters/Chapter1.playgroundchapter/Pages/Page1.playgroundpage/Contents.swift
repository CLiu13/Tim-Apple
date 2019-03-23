import UIKit
import PlaygroundSupport

let messenger = Messenger()
let solution = "`pushApple(direction: \"right\")`"

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
