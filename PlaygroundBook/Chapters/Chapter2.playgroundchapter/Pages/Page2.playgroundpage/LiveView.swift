//
//  LiveView.swift
//  Created by Charlie Liu for WWDC19
//

import UIKit
import PlaygroundSupport

let viewController = LiveViewController()
viewController.numBlocks = 10
viewController.blocksDrag = false
// This level is from right-to-left
viewController.oppositeView = true
PlaygroundPage.current.liveView = viewController
