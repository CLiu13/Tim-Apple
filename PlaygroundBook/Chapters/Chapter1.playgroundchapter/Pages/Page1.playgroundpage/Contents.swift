//#-hidden-code
//#-end-hidden-code
//#-editable-code
import UIKit
import PlaygroundSupport

var blocks: [Rectangle] = []
var floors: [Rectangle] = []

for i in 1...5 {
    blocks.append(Rectangle(width: 2, height: Double(20 + i * 2), cornerRadius: 0.5))
}

floors.append(Rectangle(width: 20, height: 22, cornerRadius: 2))
floors.append(Rectangle(width: 20, height: 30, cornerRadius: 2))

let tim = Image(name: "tim")
let apple = Image(name: "apple-normal")

tim.draggable = true
apple.draggable = true

let xPoints: [Double] = [-6, -3, 0, 3, 6]

func getNearestXPoint(currentX: Double) -> Double {
    var diff: Double = 100
    var nearestX: Double = 0

    for x in xPoints {
        if abs(x - currentX) < diff {
            diff = abs(x - currentX)
            nearestX = x
        }
    }

    return nearestX
}

for block in blocks {
    block.center = Point(x: Double(-6 + blocks.firstIndex(of: block)! * 3), y: Double(-30 + block.size.height / 2))

    block.draggable = true

    block.onTouchDown {
        block.dropShadow = Shadow()
    }

    block.onTouchUp {
        block.dropShadow = nil

        animate {
            block.center = Point(x: getNearestXPoint(currentX: block.center.x), y: Double(-30 + block.size.height / 2))
        }
    }
}

for floor in floors {
    floor.draggable = true

    floor.onTouchDown {
        floor.dropShadow = Shadow()
    }

    floor.onTouchUp {
        floor.dropShadow = nil
    }
}

let viewController = UIViewController()
viewController.view = Canvas.shared.backingView

let animator = UIDynamicAnimator(referenceView: viewController.view)

viewController.view.addSubview(apple.backingViewAsImageView)

let gravity = UIGravityBehavior(items: [apple.backingViewAsImageView])
animator.addBehavior(gravity)

let collision = UICollisionBehavior(items: [apple.backingViewAsImageView, tim.backingViewAsImageView])
collision.collisionMode = .everything
collision.translatesReferenceBoundsIntoBoundary = true
animator.addBehavior(collision)

PlaygroundPage.current.liveView = viewController
//#-end-editable-code
