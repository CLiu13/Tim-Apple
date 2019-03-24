import UIKit
import PlaygroundSupport

let viewController = LiveViewController()
viewController.numBlocks = 10
viewController.blocksDrag = false
viewController.oppositeView = true
PlaygroundPage.current.liveView = viewController
