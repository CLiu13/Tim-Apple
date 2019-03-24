//
//  LiveView.swift
//  Created by Charlie Liu for WWDC19
//

import UIKit
import AVFoundation
import PlaygroundSupport

/**
 View class, where all objects are present
 */
public class LiveView: UIView {
    // Primary structures
    public var blocks: [Rectangle]?
    public var platforms: [Rectangle]?

    // Assisting structures
    public var xBounds: [Double]?
    public var artificialGround: Rectangle?

    // Characters
    public var apple: Image?
    public var tim: Image?

    // Adjustable values
    public var numBlocks: Int?
    public var blocksDrag: Bool = true
    public var oppositeView: Bool = false

    // Used when sorting
    public var tallestBlock: Int?
    public var currentBlock: Int?

    // For sounds
    public var player: AVAudioPlayer?

    // Create view once loaded
    override public func didMoveToSuperview() {
        createView()
    }

    /**
     Method to create a set of blocks based on certain constraints, given in coordinate form
     */
    public func createBlocks(minX: Double, maxX: Double, minY: Double, maxY: Double) -> [Rectangle] {
        var blocks: [Rectangle] = []
        var block: Rectangle

        // Custom equations, hand-calculated, to work with any set of constraints
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

    /**
     Method to create a set of platforms based on certain constraints, given in coordinate form
     */
    public func createPlatforms(minX: Double, maxX: Double, minY: Double, maxY: Double) -> [Rectangle] {
        // More custom, hand-calculated equations related to constraints
        let width = (0.5 * (maxX - minX) - 2.2) / 2
        let tallHeight = blocks![0].size.height + 0.5
        let shortHeight = blocks!.last!.size.height

        let platform1 = Rectangle(width: width, height: tallHeight, cornerRadius: 1)
        let platform2 = Rectangle(width: width, height: shortHeight, cornerRadius: 1)

        // Flip arrangement of platforms if desired
        if oppositeView {
            platform1.center = Point(x: maxX - 1 - width / 2, y: blocks![0].center.y)
            platform2.center = Point(x: minX + 1 + width / 2, y: blocks!.last!.center.y)
        } else {
            platform1.center = Point(x: minX + 1 + width / 2, y: blocks![0].center.y)
            platform2.center = Point(x: maxX - 1 - width / 2, y: blocks!.last!.center.y)
        }

        platform1.color = .gray
        platform2.color = .gray

        return [platform1, platform2]
    }

    /**
     Method to create an artificial ground that prevents blocks/platforms from falling
     */
    public func createArtificialGround() -> Rectangle {
        // FUTURE IMPROVEMENT: Calculate these values, rather than hard-coding
        let artificialGround = Rectangle(width: 60.0, height: 8.0, cornerRadius: 0)
        artificialGround.center = Point(x: 0, y: -31)
        artificialGround.color = .clear

        return artificialGround
    }

    /**
     Method to create the characters (Tim and his apple)
     */
    public func createCharacters() -> [Image] {
        let tim = Image(name: "tim")
        let apple = Image(name: "apple")

        tim.size = Size(width: 10, height: 10)
        apple.size = Size(width: 5, height: 5)

        // More custom, hand-calculated calculations that determine object positions
        tim.center = Point(x: platforms!.last!.center.x, y: platforms!.last!.center.y + platforms!.last!.size.height / 2 + tim.size.height / 2 + 1)
        apple.center = Point(x: platforms![0].center.x, y: platforms![0].center.y + platforms![0].size.height / 2 + apple.size.height / 2 + 1)

        return [tim, apple]
    }

    /**
     Method to create a set of x-bounds (the x-values that blocks "snap" back to)
     */
    public func createXBounds() -> [Double] {
        var xBounds: [Double] = []
        for block in blocks! {
            xBounds.append(block.center.x)
        }
        return xBounds
    }

    /**
     Method to determine the nearest x-bound for a block to "snap" back to
     */
    public func getNearestXBound(currentX: Double) -> Double {
        var diff: Double = Double(Int.max)
        var nearestXBound: Double = 0
        for x in xBounds! {
            if abs(x - currentX) < diff {
                diff = abs(x - currentX)
                nearestXBound = x
            }
        }
        return nearestXBound
    }

    /**
     Method to handle how blocks "snap" back into a pre-defined position (x-bound)
     */
    public func snapBlocks(minY: Double, maxY: Double) {
        // More custom, hand-calculated calculations related to constraints
        let startY = minY - (0.75 * (maxY - minY) / (Double(numBlocks!) * 0.1 + 1)) / 4

        for block in blocks! {
            // Add a cool shadow effect to let the user know that they picked up the object
            block.onTouchDown {
                block.dropShadow = Shadow()
            }

            block.onTouchUp {
                // Remove the cool shadow effect to let the user know that they dropped the object
                block.dropShadow = nil

                // Blocks gently "snap" back into a pre-defined place (x-bound) instead of floating around randomly
                let changesToAnimate = {
                    block.center = Point(x: self.getNearestXBound(currentX: block.center.x), y: startY + block.size.height / 2)
                }
                UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.beginFromCurrentState, .allowUserInteraction], animations: changesToAnimate, completion: nil)

                // After adjusting those blocks, make sure there is no overlap
                self.updateBlocks(currentBlocks: [block])
            }
        }
    }

    /**
     Method to shuffle the positions of blocks
     */
    public func shuffleBlocks() -> [Rectangle] {
        var shuffledXBounds = xBounds!.shuffled()

        while shuffledXBounds == xBounds! {
            shuffledXBounds = xBounds!.shuffled()
        }

        for i in 0...blocks!.count - 1 {
            blocks![i].center.x = shuffledXBounds[i]
        }

        return blocks!
    }

    /**
     Method to adjust the position of other blocks to prevent any overlap
     */
    public func updateBlocks(currentBlocks: [Rectangle]) {
        var remainingXBound: [Double] = []
        for xBound in xBounds! {
            // Values need to be rounded to the nearest thousandth
            remainingXBound.append((xBound * 1000).rounded() / 1000)
        }

        for block in blocks! {
            // There should only be one unoccupied x-bound left
            if let index = remainingXBound.index(of: (block.center.x * 1000).rounded() / 1000) {
                remainingXBound.remove(at: index)
            }
        }

        var currentXs: [Double] = []
        for currentBlock in currentBlocks {
            currentXs.append((currentBlock.center.x * 1000).rounded() / 1000)
        }

        // Shift the blocks around based on the current occupied x-bounds and the sole unoccupied x-bound
        for block in blocks! {
            if currentXs.contains((block.center.x * 1000).rounded() / 1000) && !(currentBlocks.contains(block)) {
                let changesToAnimate = {
                    block.center.x = remainingXBound[0]
                }
                UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.beginFromCurrentState, .allowUserInteraction], animations: changesToAnimate, completion: nil)
                // Since there should be only one unoccupied x-bound, we can exit now
                break
            }
        }
    }

    /**
     Method to adjust the position of blocks based on their position in the array of blocks
     */
    public func updateBlocksByArrayPosition(index1: Int, index2: Int) {
        let changesToAnimate = {
            self.blocks![index1].center.x = self.xBounds![index1]
            self.blocks![index2].center.x = self.xBounds![index2]
        }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.beginFromCurrentState, .allowUserInteraction], animations: changesToAnimate, completion: nil)

        // After adjusting those blocks, make sure there is no overlap
        updateBlocks(currentBlocks: [self.blocks![index1], self.blocks![index2]])
    }

    /**
     Method to create the view with all the objects
     */
    public func createView() {
        self.addSubview(Canvas.shared.backingView)
        self.backgroundColor = .cyan

        // FUTURE IMPROVEMENT: Calculate these values, rather than hard-coding
        self.blocks = createBlocks(minX: -30, maxX: 30, minY: -20, maxY: 40)
        self.platforms = createPlatforms(minX: -30, maxX: 30, minY: -20, maxY: 40)
        self.artificialGround = createArtificialGround()
        self.xBounds = createXBounds()
        let characters = createCharacters()

        self.tim = characters[0]
        self.apple = characters[1]

        snapBlocks(minY: -20, maxY: 40)
        self.blocks = shuffleBlocks()

        // For playing the "success" sound
        self.player = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "successSoundEffect", withExtension: "wav")!)
        player!.prepareToPlay()
    }

    /**
     Method that is part of the selection sort algorithm
     */
    public func getTallestBlock(index: Int) {
        let blocks = self.blocks!

        var max = index
        for i in (index + 1)...(blocks.count - 1) {
            if blocks[i].size.height > blocks[max].size.height {
                max = i
            }
        }

        blocks[max].color = .yellow
        if index == 8 {
            // Just for visual effect, all blocks should be colored yellow
            blocks[9].color = .yellow
        }

        self.tallestBlock = max
    }

    /**
     Method that is part of the selection sort algorithm
     */
    public func moveTallestToFront(index: Int) {
        if index != self.tallestBlock! {
            blocks!.swapAt(index, tallestBlock!)
        }
        updateBlocksByArrayPosition(index1: index, index2: tallestBlock!)
    }

    /**
     Method that is part of the insertion sort algorithm
     */
    public func getCurrentBlock(index: Int) {
        let blocks = self.blocks!
        self.currentBlock = index

        blocks[index].color = .yellow
        if index == 1 {
            // Just for visual effect, all blocks should be colored yellow
            blocks[0].color = .yellow
        }
    }

    /**
     Method that is part of the insertion sort algorithm
     */
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
