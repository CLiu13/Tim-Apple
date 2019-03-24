import UIKit
import PlaygroundSupport

public class LiveViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
    private var animator: UIDynamicAnimator?

    public override func viewDidLoad() {
        let view = LiveView()
        self.view = view
        self.animator = UIDynamicAnimator(referenceView: self.view)
    }

    public func receive(_ value: PlaygroundValue) {
        guard case let .dictionary(dictionary) = value else {
            return
        }
        guard case let .string(message)? = dictionary["Message"] else {
            return
        }

        switch message {
        case "PushApple":
            self.pushApple(apple: ((self.view as! LiveView).apple?.backingView)!, strength: 0.75)
        default:
            return
        }
    }

    public func addGravity(_ objects: [UIDynamicItem]) {
        let gravity = UIGravityBehavior(items: objects)
        self.animator!.addBehavior(gravity)
    }

    public func addCollisions(objects: [UIDynamicItem]) {
        let collision = UICollisionBehavior(items: objects)
        collision.translatesReferenceBoundsIntoBoundary = true
        self.animator!.addBehavior(collision)

        collision.action = {
            if ((self.view as! LiveView).apple!.backingView).frame.intersects(((self.view as! LiveView).tim!.backingView).frame) {
                self.view.backgroundColor = .green
                self.send(.string("Success"))
            }
        }
    }

    public func pushApple(apple: UIDynamicItem, strength: Double) {
        var allObjects = [((self.view as! LiveView).apple?.backingView)!, ((self.view as! LiveView).tim?.backingView)!, ((self.view as! LiveView).artificialGround?.backingView)!]
        for block in (self.view as! LiveView).blocks! {
            allObjects.append(block.backingView)
        }
        for platform in (self.view as! LiveView).platforms! {
            allObjects.append(platform.backingView)
        }

        self.addGravity([((self.view as! LiveView).apple?.backingView)!, ((self.view as! LiveView).tim?.backingView)!])
        self.addCollisions(objects: allObjects)

        let push = UIPushBehavior(items: [apple], mode: .instantaneous)
        push.pushDirection = CGVector(dx: strength, dy: 0)
        self.animator!.addBehavior(push)
    }
}
