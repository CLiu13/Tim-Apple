import UIKit
import PlaygroundSupport

public class LiveView: UIView {
    public var apple: Image?
    public var tim: Image?
    public var blocks: [Rectangle]?
    public var platforms: [Rectangle]?
    public var artificialGround: Rectangle?

    override public func didMoveToSuperview() {
        self.addSubview(Canvas.shared.backingView)
        self.backgroundColor = .white

        self.blocks = createBlocks(num: 5, minX: -30, maxX: 30, minY: -20, maxY: 40)
        self.platforms = createPlatforms(blocks: blocks!, minX: -30, maxX: 30, minY: -20, maxY: 40)
        self.artificialGround = createArtificialGround()
        let characters = createCharacters(platforms: platforms!)
        let xBounds = createXBounds(blocks: blocks!)

        self.tim = characters[0]
        self.apple = characters[1]

        snapBlocks(blocks: blocks!, xBounds: xBounds, startY: -27.5) // TODO: Need to replace hard-coded value with calculations
        self.blocks = shuffleBlocks(blocks: blocks!, xBounds: xBounds)
    }

    public func createBlocks(num: Int, minX: Double, maxX: Double, minY: Double, maxY: Double) -> [Rectangle] {
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

    public func createPlatforms(blocks: [Rectangle], minX: Double, maxX: Double, minY: Double, maxY: Double) -> [Rectangle] {
        let width = (0.5 * (maxX - minX) - 2.2) / 2
        let shortHeight = blocks[0].size.height
        let tallHeight = blocks.last!.size.height

        let platform1 = Rectangle(width: width, height: shortHeight, cornerRadius: 1)
        let platform2 = Rectangle(width: width, height: tallHeight, cornerRadius: 1)

        platform1.center = Point(x: minX + 1 + width / 2, y: blocks[0].center.y)
        platform2.center = Point(x: maxX - 1 - width / 2, y: blocks.last!.center.y)

        platform1.color = .gray
        platform2.color = .gray

        return [platform1, platform2]
    }

    // TODO: NEED TO CUSTOMIZE
    public func createArtificialGround() -> Rectangle {
        let fakeGround = Rectangle(width: 60, height: 8, cornerRadius: 0) // TODO: Need to replace hard-coded value with calculations
        fakeGround.center = Point(x: 0, y: -31) // TODO: Need to replace hard-coded value with calculations
        fakeGround.color = .white

        return fakeGround
    }

    public func createCharacters(platforms: [Rectangle]) -> [Image] {
        let tim = Image(name: "tim")
        let apple = Image(name: "apple")

        tim.size = Size(width: 10, height: 10)
        apple.size = Size(width: 5, height: 5)

        tim.center = Point(x: platforms.last!.center.x, y: platforms.last!.center.y + platforms.last!.size.height / 2 + tim.size.height / 2 + 1)
        apple.center = Point(x: platforms[0].center.x, y: platforms[0].center.y + platforms[0].size.height / 2 + apple.size.height / 2 + 1)

        return [tim, apple]
    }

    public func createXBounds(blocks: [Rectangle]) -> [Double] {
        var xBounds: [Double] = []

        for block in blocks {
            xBounds.append(block.center.x)
        }

        return xBounds
    }

    public func getNearestXBound(xBounds: [Double], currentX: Double) -> Double {
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

    public func snapBlocks(blocks: [Rectangle], xBounds: [Double], startY: Double) {
        for block in blocks {
            block.onTouchDown {
                block.dropShadow = Shadow()
            }

            block.onTouchUp {
                block.dropShadow = nil

                let changesToAnimate = {
                    block.center = Point(x: self.getNearestXBound(xBounds: xBounds, currentX: block.center.x), y: startY + block.size.height / 2)
                }
                UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.beginFromCurrentState, .allowUserInteraction], animations: changesToAnimate, completion: nil)

                self.updateBlocks(blocks: blocks, xBounds: xBounds, currentBlock: block)
            }
        }
    }

    public func shuffleBlocks(blocks: [Rectangle], xBounds: [Double]) -> [Rectangle] {
        var shuffledXBounds = xBounds.shuffled()

        while shuffledXBounds == xBounds {
            shuffledXBounds = xBounds.shuffled()
        }

        for i in 0...blocks.count - 1 {
            blocks[i].center.x = shuffledXBounds[i]
        }

        return blocks
    }

    public func setBlocksDrag(blocks: [Rectangle], draggable: Bool) -> [Rectangle] {
        for block in blocks {
            block.draggable = draggable
        }
        return blocks
    }

    public func updateBlocks(blocks: [Rectangle], xBounds: [Double], currentBlock: Rectangle) {
        var remainingXBound = xBounds

        for block in blocks {
            if let index = remainingXBound.index(of: (block.center.x * 100).rounded() / 100) {
                remainingXBound.remove(at: index)
            }
        }

        for block in blocks {
            if ((block.center.x * 100).rounded() / 100 == (currentBlock.center.x * 100).rounded() / 100) && (block != currentBlock) {
                let changesToAnimate = {
                    block.center.x = remainingXBound[0]
                }
                UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.beginFromCurrentState, .allowUserInteraction], animations: changesToAnimate, completion: nil)
                break
            }
        }
    }
}
