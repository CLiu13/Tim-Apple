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
            self.pushApple(apple: ((self.view as! LiveView).apple?.backingView)!, strength: 1)
        default:
            return
        }
    }

    public func addGravity(_ object: UIDynamicItem) {
        let gravity = UIGravityBehavior(items: [object])
        self.animator!.addBehavior(gravity)
    }

    public func addCollisions(objects: [UIDynamicItem]) {
        let collision = UICollisionBehavior(items: objects)
        collision.translatesReferenceBoundsIntoBoundary = true
        self.animator!.addBehavior(collision)

        collision.action = {
            if ((self.view as! LiveView).apple!.backingView).frame.intersects(((self.view as! LiveView).tim!.backingView).frame) {
                self.view.backgroundColor = .green
                PlaygroundPage.current.assessmentStatus = .pass(message: "Nicely done! Let's move on. [Next](@next)")
            }
        }
    }

    public func pushApple(apple: UIDynamicItem, strength: Double) {
        let allObjects = [((self.view as! LiveView).apple?.backingView)!, ((self.view as! LiveView).tim?.backingView)!, ((self.view as! LiveView).blocks![0].backingView), ((self.view as! LiveView).blocks![1].backingView), ((self.view as! LiveView).blocks![2].backingView), ((self.view as! LiveView).blocks![3].backingView), ((self.view as! LiveView).blocks![4].backingView), ((self.view as! LiveView).platforms![0].backingView), ((self.view as! LiveView).platforms![1].backingView), ((self.view as! LiveView).artificialGround?.backingView)!]

        self.addGravity(((self.view as! LiveView).apple?.backingView)!)
        self.addCollisions(objects: allObjects)

        let push = UIPushBehavior(items: [apple], mode: .instantaneous)
        push.pushDirection = CGVector(dx: strength, dy: 0)
        self.animator!.addBehavior(push)
    }
}
