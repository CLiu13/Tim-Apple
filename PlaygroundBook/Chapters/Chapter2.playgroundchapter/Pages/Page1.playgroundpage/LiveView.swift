import UIKit
import PlaygroundSupport

let viewController = LiveViewController()
viewController.numBlocks = 10
viewController.blocksDrag = false
PlaygroundPage.current.liveView = viewController
