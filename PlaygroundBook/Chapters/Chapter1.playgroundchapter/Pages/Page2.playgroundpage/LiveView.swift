//
//  LiveView.swift
//  Created by Charlie Liu for WWDC19
//

import UIKit
import PlaygroundSupport

let viewController = LiveViewController()
viewController.numBlocks = 10
PlaygroundPage.current.liveView = viewController
