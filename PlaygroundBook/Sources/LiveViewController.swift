//
//  LiveViewController.swift
//  Created by Charlie Liu for WWDC19
//

import UIKit
import PlaygroundSupport

/**
 ViewController class
 */
public class LiveViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
    // Animator used for physics
    private var animator: UIDynamicAnimator?

    // Adjustable values
    public var numBlocks: Int?
    public var blocksDrag: Bool = true
    public var oppositeView: Bool = false

    // Used when sorting
    public var tallestBlock: Int?

    // Create everything once loaded
    public override func viewDidLoad() {
        let view = LiveView()
        view.numBlocks = numBlocks!
        view.blocksDrag = blocksDrag
        view.oppositeView = oppositeView
        self.view = view

        self.animator = UIDynamicAnimator(referenceView: self.view)
    }

    /**
     Method to recieve messages from the playground page
     */
    public func receive(_ value: PlaygroundValue) {
        // Break apart the message into its components
        guard case let .dictionary(dictionary) = value else {
            return
        }
        guard case let .string(message)? = dictionary["Message"] else {
            return
        }

        switch message {
        case "PushApple":
            self.pushApple(apple: ((self.view as! LiveView).apple?.backingView)!, strength: 0.7)
        case "Reset":
            self.reset()
        case "GetTallestBlock":
            // If there is a payload, extract it
            if case let .integer(payload)? = dictionary["Payload"] {
                (self.view as! LiveView).getTallestBlock(index: payload)
            }
        case "MoveTallestToFront":
            if case let .integer(payload)? = dictionary["Payload"] {
                (self.view as! LiveView).moveTallestToFront(index: payload)
            }
        case "GetCurrentBlock":
            if case let .integer(payload)? = dictionary["Payload"] {
                (self.view as! LiveView).getCurrentBlock(index: payload)
            }
        case "MoveBlockUntilFit":
            (self.view as! LiveView).moveBlockUntilFit()
        default:
            return
        }
    }

    /**
     Method to set the drag-ability of all blocks
     */
    public func setBlocksDrag(blocks: [Rectangle], draggable: Bool) {
        for block in blocks {
            block.draggable = draggable
        }
    }

    /**
     Method to add gravity to objects
     */
    public func addGravity(_ objects: [UIDynamicItem]) {
        let gravity = UIGravityBehavior(items: objects)
        self.animator!.addBehavior(gravity)
    }

    /**
     Method to add collisions between objects
     */
    public func addCollisions(objects: [UIDynamicItem]) {
        let collision = UICollisionBehavior(items: objects)
        collision.translatesReferenceBoundsIntoBoundary = true
        self.animator!.addBehavior(collision)

        collision.action = {
            // If the apple bumps into Tim, that is a success
            if ((self.view as! LiveView).apple!.backingView).frame.intersects(((self.view as! LiveView).tim!.backingView).frame) {
                // Stop the physics and sound after a short bit
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.animator!.removeAllBehaviors()
                    (self.view as! LiveView).player?.stop()
                }
                // Visual cue for success
                (self.view as! LiveView).backgroundColor = .green
                // Audio cue for success
                (self.view as! LiveView).player?.play()
                // Tell the playground page that success was achieved
                self.send(.string("Success"))
            }
        }
    }

    /**
     Method to push the apple in a certain manner
     */
    public func pushApple(apple: UIDynamicItem, strength: Double) {
        // Once the apple is pushed, blocks shouldn't be moved by player
        setBlocksDrag(blocks: (self.view as! LiveView).blocks!, draggable: false)

        // Get a list of all the objects
        var allObjects = [((self.view as! LiveView).apple?.backingView)!, ((self.view as! LiveView).tim?.backingView)!, ((self.view as! LiveView).artificialGround?.backingView)!]
        for block in (self.view as! LiveView).blocks! {
            allObjects.append(block.backingView)
        }
        for platform in (self.view as! LiveView).platforms! {
            allObjects.append(platform.backingView)
        }

        // Add all the physics
        self.addGravity([((self.view as! LiveView).apple?.backingView)!, ((self.view as! LiveView).tim?.backingView)!])
        self.addCollisions(objects: allObjects)

        let push = UIPushBehavior(items: [apple], mode: .instantaneous)
        // Push either left or right
        if oppositeView {
            push.pushDirection = CGVector(dx: -strength, dy: 0)
        } else {
            push.pushDirection = CGVector(dx: strength, dy: 0)
        }
        self.animator!.addBehavior(push)
    }

    /**
     Method to completely reset the view
     */
    public func reset() {
        Canvas.shared.clear()
        (self.view as! LiveView).createView()
    }
}
