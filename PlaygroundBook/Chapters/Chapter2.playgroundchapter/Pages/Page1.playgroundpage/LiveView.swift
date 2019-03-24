//
//  LiveView.swift
//  Created by Charlie Liu for WWDC19
//

import UIKit
import PlaygroundSupport

let viewController = LiveViewController()
viewController.numBlocks = 10
// No need to manually sort blocks
viewController.blocksDrag = false
PlaygroundPage.current.liveView = viewController
