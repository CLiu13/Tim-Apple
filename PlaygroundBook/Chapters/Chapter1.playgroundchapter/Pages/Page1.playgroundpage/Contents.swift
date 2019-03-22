//#-hidden-code
//#-end-hidden-code
//#-editable-code
import UIKit
import PlaygroundSupport

// Based on the liveView grid dimensions, create a certain number of blocks
func createBlocks(num: Int, minX: Double, maxX: Double, minY: Double, maxY: Double) -> [Rectangle] {
    var blocks: [Rectangle] = []
    var block: Rectangle

    let width = (0.5 * (maxX - minX) + 0.1 - Double(num) * 0.1) / Double(num)
    let height = 0.75 * (maxY - minY) / (Double(num) * 0.1 + 1)

    let startX = 0 - Double(num - 1) * (width + 0.1) / 2
    let startY = minY - height / 4

    for i in 0...num - 1 {
        block = Rectangle(width: width, height: height - Double(i) * height / 10, cornerRadius: 0.5)
        block.center = Point(x: startX + Double(i) * (width + 0.1), y: startY + block.size.height / 2)

        block.draggable = true

        blocks.append(block)
    }

    return blocks
}

// Based on the liveView grid dimensions and set of blocks, create two platforms
func createPlatforms(blocks: [Rectangle], minX: Double, maxX: Double, minY: Double, maxY: Double) -> [Rectangle] {
    let width = (0.5 * (maxX - minX) - 2.2) / 2
    let shortHeight = blocks[0].size.height
    let tallHeight = blocks.last!.size.height

    var platform1 = Rectangle(width: width, height: shortHeight, cornerRadius: 1)
    var platform2 = Rectangle(width: width, height: tallHeight, cornerRadius: 1)

    platform1.center = Point(x: minX + 1 + width / 2, y: blocks[0].center.y)
    platform2.center = Point(x: maxX - 1 - width / 2, y: blocks.last!.center.y)

    platform1.color = .gray
    platform2.color = .gray

    return [platform1, platform2]
}

// Based on a set of blocks, create x-bounds for the blocks to snap into
func createXBounds(blocks: [Rectangle]) -> [Double] {
    var xBounds: [Double] = []

    for block in blocks {
        xBounds.append(block.center.x)
    }

    return xBounds
}

// Based on a set of x-bounds, get the closest one relative to a current x
func getNearestXBound(xBounds: [Double], currentX: Double) -> Double {
    var diff: Double = Double(Int.max)
    var nearestXBound: Double = 0

    for x in xBounds {
        if abs(x - currentX) < diff {
            diff = abs(x - currentX)
            nearestXBound = x
        }
    }

    return nearestXBound
}

// Given a set of blocks, have them snap into position after dragged
func snapBlocks(blocks: [Rectangle], xBounds: [Double], startY: Double) {
    for block in blocks {
        block.onTouchDown {
            block.dropShadow = Shadow()
        }

        block.onTouchUp {
            block.dropShadow = nil

            animate {
                block.center = Point(x: getNearestXBound(xBounds: xBounds, currentX: block.center.x), y: startY + block.size.height / 2)
            }
        }
    }
}

var blocks = createBlocks(num: 5, minX: -30, maxX: 30, minY: -20, maxY: 40)
var platforms = createPlatforms(blocks: blocks, minX: -30, maxX: 30, minY: -20, maxY: 40)

let xBounds = createXBounds(blocks: blocks)
snapBlocks(blocks: blocks, xBounds: xBounds, startY: -27.5) // TODO: Need to replace hard-coded value with calculations

// **** //

let tim = Image(name: "tim")
let apple = Image(name: "apple-normal")

tim.size = Size(width: 10, height: 10)
apple.size = Size(width: 5, height: 5)

apple.center = Point(x: platforms[0].center.x, y: platforms[0].center.y + 20)

// **** //

let viewController = UIViewController()
viewController.view = Canvas.shared.backingView

let animator = UIDynamicAnimator(referenceView: viewController.view)
animator.setValue(true, forKey: "debugEnabled")

// Create text button that, when tapped, will slightly push the apple to the left
let pushAppleButton = Text(string: "Push Apple!", fontSize: 21.0)
pushAppleButton.color = .blue
pushAppleButton.center.y = 10

pushAppleButton.onTouchUp {
    let push = UIPushBehavior(items: [apple.backingView], mode: .instantaneous)
    push.pushDirection = CGVector(dx: 0.5, dy: 0)
    animator.addBehavior(push)

    let gravity = UIGravityBehavior(items: [apple.backingView])
    animator.addBehavior(gravity)

    let collision = UICollisionBehavior(items: [platforms[0].backingView, apple.backingView, blocks[0].backingView, blocks[1].backingView, blocks[2].backingView, blocks[3].backingView, blocks[4].backingView, platforms[1].backingView])
    collision.translatesReferenceBoundsIntoBoundary = true
    animator.addBehavior(collision)

    // Button can only be used once
    pushAppleButton.backingView.removeFromSuperview()
}

PlaygroundPage.current.liveView = viewController
//#-end-editable-code
