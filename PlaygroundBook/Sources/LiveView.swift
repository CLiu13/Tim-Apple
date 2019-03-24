import UIKit
import PlaygroundSupport

public class LiveView: UIView {
    public var apple: Image?
    public var tim: Image?
    public var blocks: [Rectangle]?
    public var platforms: [Rectangle]?
    public var xBounds: [Double]?
    public var artificialGround: Rectangle?

    public var numBlocks: Int?
    public var blocksDrag: Bool = true
    public var oppositeView: Bool = false

    public var tallestBlock: Int?
    public var currentBlock: Int?

    override public func didMoveToSuperview() {
        createView()
    }

    public func createBlocks(minX: Double, maxX: Double, minY: Double, maxY: Double) -> [Rectangle] {
        var blocks: [Rectangle] = []
        var block: Rectangle

        let width = (0.5 * (maxX - minX) + 0.1 - Double(numBlocks!) * 0.1) / Double(numBlocks!)
        let height = 0.75 * (maxY - minY) / (Double(numBlocks!) * 0.1 + 1)

        let startX = 0 - Double(numBlocks! - 1) * (width + 0.1) / 2
        let startY = minY - height / 4

        for i in 0...numBlocks! - 1 {
            block = Rectangle(width: width, height: height - Double(i) * height / 10, cornerRadius: 0.5)
            block.center = Point(x: startX + Double(i) * (width + 0.1), y: startY + block.size.height / 2)
            block.draggable = blocksDrag

            blocks.append(block)
        }

        return blocks
    }

    public func createPlatforms(blocks: [Rectangle], minX: Double, maxX: Double, minY: Double, maxY: Double) -> [Rectangle] {
        let width = (0.5 * (maxX - minX) - 2.2) / 2
        let tallHeight = blocks[0].size.height + 0.5
        let shortHeight = blocks.last!.size.height

        let platform1 = Rectangle(width: width, height: tallHeight, cornerRadius: 1)
        let platform2 = Rectangle(width: width, height: shortHeight, cornerRadius: 1)

        if oppositeView {
            platform1.center = Point(x: maxX - 1 - width / 2, y: blocks[0].center.y)
            platform2.center = Point(x: minX + 1 + width / 2, y: blocks.last!.center.y)
        } else {
            platform1.center = Point(x: minX + 1 + width / 2, y: blocks[0].center.y)
            platform2.center = Point(x: maxX - 1 - width / 2, y: blocks.last!.center.y)
        }

        platform1.color = .gray
        platform2.color = .gray

        return [platform1, platform2]
    }

    public func createArtificialGround(platforms: [Rectangle]) -> Rectangle {
        let artificialGround = Rectangle(width: 60.0, height: 8.0, cornerRadius: 0)
        artificialGround.center = Point(x: 0, y: -31)
        artificialGround.color = .clear

        return artificialGround
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

    public func snapBlocks(blocks: [Rectangle], xBounds: [Double], minY: Double, maxY: Double) {
        let startY = minY - (0.75 * (maxY - minY) / (Double(numBlocks!) * 0.1 + 1)) / 4

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

                self.updateBlocks(blocks: blocks, xBounds: xBounds, currentBlocks: [block])
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

    public func updateBlocks(blocks: [Rectangle], xBounds: [Double], currentBlocks: [Rectangle]) {
        var remainingXBound: [Double] = []
        for xBound in xBounds {
            remainingXBound.append((xBound * 1000).rounded() / 1000)
        }

        for block in blocks {
            if let index = remainingXBound.index(of: (block.center.x * 1000).rounded() / 1000) {
                remainingXBound.remove(at: index)
            }
        }

        var currentXs: [Double] = []
        for currentBlock in currentBlocks {
            currentXs.append((currentBlock.center.x * 1000).rounded() / 1000)
        }

        for block in blocks {
            if currentXs.contains((block.center.x * 1000).rounded() / 1000) && !(currentBlocks.contains(block)) {
                let changesToAnimate = {
                    block.center.x = remainingXBound[0]
                }
                UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.beginFromCurrentState, .allowUserInteraction], animations: changesToAnimate, completion: nil)
                break
            }
        }
    }

    public func createView() {
        self.addSubview(Canvas.shared.backingView)
        self.backgroundColor = .white

        self.blocks = createBlocks(minX: -30, maxX: 30, minY: -20, maxY: 40)
        self.platforms = createPlatforms(blocks: blocks!, minX: -30, maxX: 30, minY: -20, maxY: 40)
        self.artificialGround = createArtificialGround(platforms: platforms!)
        self.xBounds = createXBounds(blocks: blocks!)
        let characters = createCharacters(platforms: platforms!)

        self.tim = characters[0]
        self.apple = characters[1]

        snapBlocks(blocks: blocks!, xBounds: xBounds!, minY: -20, maxY: 40)
        self.blocks = shuffleBlocks(blocks: blocks!, xBounds: xBounds!)
    }

    public func updateBlocksByArrayPosition(index1: Int, index2: Int) {
        let changesToAnimate = {
            self.blocks![index1].center.x = self.xBounds![index1]
            self.blocks![index2].center.x = self.xBounds![index2]
        }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.beginFromCurrentState, .allowUserInteraction], animations: changesToAnimate, completion: nil)

        updateBlocks(blocks: blocks!, xBounds: xBounds!, currentBlocks: [self.blocks![index1], self.blocks![index2]])
    }

    public func getTallestBlock(index: Int) {
        let blocks = self.blocks!

        var max = index

        for i in (index + 1)...(blocks.count - 1) {
            if blocks[i].size.height > blocks[max].size.height {
                max = i
            }
        }

        if index == 8 {
            blocks[9].color = .yellow
        }
        blocks[max].color = .yellow

        self.tallestBlock = max
    }

    public func moveTallestToFront(index: Int) {
        if index != self.tallestBlock! {
            blocks!.swapAt(index, tallestBlock!)
        }
        updateBlocksByArrayPosition(index1: index, index2: tallestBlock!)
    }

    public func getCurrentBlock(index: Int) {
        let blocks = self.blocks!
        self.currentBlock = index

        if index == 1 {
            blocks[0].color = .yellow
        }
        blocks[index].color = .yellow
    }

    public func moveBlockUntilFit() {
        let temp = blocks![currentBlock!]
        var index = currentBlock!

        while index > 0 && temp.size.height < blocks![index - 1].size.height {
            blocks!.swapAt(index, index - 1)
            updateBlocksByArrayPosition(index1: index, index2: index - 1)
            index -= 1
        }
    }
}
