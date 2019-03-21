//#-hidden-code
_setup()
//#-end-hidden-code
//#-editable-code Tap to enter code
var blocks: [Rectangle] = []

for i in 1...5 {
    blocks.append(Rectangle(width: 2, height: Double(20 + i * 2), cornerRadius: 0.5))
}

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
//#-end-editable-code
