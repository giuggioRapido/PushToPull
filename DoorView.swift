//
//  DoorView.swift
//  PushToPullPractice
//
//  Created by Chris on 3/4/16.
//  Copyright © 2016 Prince Fungus. All rights reserved.
//

import UIKit


protocol DoorViewDelegate {
    func doorDidOpen(door: DoorView)
}

@IBDesignable class DoorView: UIView {
    /// Each DoorView is backed by a Door-type instance. 
    /// the backing door's properties are used to configure a DoorView.
    var door: Door
    var delegate: DoorViewDelegate?
    /// A DoorView has four layers: the base superlayer it comes with;
    /// a sublayer for the door itself; a sublayer for the doorframe;
    /// and a sublayer for the door handle. Separating these views into
    /// separate layers allows for custom animations to applied to each.
    var doorLayer = CALayer()
    var frameLayer = CALayer()
    var handleLayer = CALayer()
    var mask = CALayer()
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    //    override func drawRect(rect: CGRect) {
    //        let handle = UIBezierPath.init(rect: CGRectMake(10, 10, 10, 10))
    //        UIColor.blueColor().setStroke()
    //        handle.stroke()
    //    }
    
    
    // MARK: Initialization
    /// Describes possible locations for the anchorpoint corresponding
    /// to actual coordinates, for use with certain door types (e.g. hinged).
    enum AnchorPoint {
        case Top
        case Right
        case Bottom
        case Left
    }
    
    // FIXME: Get the layer created within the class. Currently method is being called in VC
    func createSubLayers() {
        /// Note: setting layer delegate necessary for allowing custom timing in a
        /// UIView animation block. Without setting the delegates, animations are
        /// handled by CALayer's default animation implementation.
        doorLayer.frame = self.bounds
        doorLayer.backgroundColor = UIColor.whiteColor().CGColor
        doorLayer.delegate = self
        self.layer.addSublayer(doorLayer)
        
        frameLayer.borderWidth = 10
        frameLayer.frame = self.bounds
        frameLayer.delegate = self
        self.layer.addSublayer(frameLayer)
        
        handleLayer.frame = CGRectMake(20, 200, 10, 30)
        handleLayer.backgroundColor = UIColor.blueColor().CGColor
        handleLayer.delegate = self
        self.doorLayer.addSublayer(handleLayer)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        let config = DoorLogicConfigurer()
        let preconfigDoor = SlidingDoor(handlePosition: .Left)
        let configuredDoor = config.configureSlidingDoor(preconfigDoor)
        door = configuredDoor
        
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        let config = DoorLogicConfigurer()
        let preconfigDoor = SlidingDoor(handlePosition: .Left)
        let configuredDoor = config.configureSlidingDoor(preconfigDoor)
        door = configuredDoor
        
        super.init(frame: frame)
    }
    
    convenience init(door: Door, frame: CGRect = CGRect.zero) {
        self.init(frame: frame)
        self.door = door
    }
    
    
    func open(swipeDirection: UISwipeGestureRecognizerDirection) {
        
        func slideOpenUp() {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.doorLayer.frame.size.height = 0
                }) { (completed) -> Void in
                    self.delegate?.doorDidOpen(self)
            }
        }
        
        func slideOpenRight() {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.doorLayer.frame.origin.x = self.doorLayer.frame.maxX
                self.doorLayer.frame.size.width = 0
                
                }) { (completed) -> Void in
                    self.delegate?.doorDidOpen(self)
                    self.walkThroughDoor()
            }
        }
        
        func slideOpenDown() {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.doorLayer.frame.origin.y = self.doorLayer.frame.maxY
                self.doorLayer.frame.size.height = 0
                }) { (completed) -> Void in
                    self.delegate?.doorDidOpen(self)
                    self.walkThroughDoor()
            }
        }
        
        func slideOpenLeft() {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.doorLayer.frame.size.width = 0
                }) { (completed) -> Void in
                    self.delegate?.doorDidOpen(self)
                    self.walkThroughDoor()
            }
        }
        

        switch swipeDirection {
        case UISwipeGestureRecognizerDirection.Up:
            slideOpenDown()
        case UISwipeGestureRecognizerDirection.Right:
            slideOpenLeft()
        case UISwipeGestureRecognizerDirection.Down:
            slideOpenUp()
        case UISwipeGestureRecognizerDirection.Left:
            slideOpenRight()
        default:
            print("Gesture not recognized: \(swipeDirection)")
        }
    }
    
    func walkThroughDoor() {
        /// We use inset to compensate for the doorframe's border thickness. In the case of a 10 pt border, we make the doorframe the size of the superview + 10 pts on each side, else we'll still see the border when animation is complete.
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            if let doorFrameLayer = self.layer.sublayers?[1] {
                doorFrameLayer.bounds = CGRectInset(self.superview!.frame, -10, -10)
            }
            
            }) { (completed) -> Void in
        }
    }

}



// MARK: To Do

/// Animates door opening on hinge
//                var rotationAndPerspectiveTransform = CATransform3DIdentity
//                rotationAndPerspectiveTransform.m34 = 1.0 / 1000
//                rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, CGFloat(75.0 * M_PI / 180.0), CGFloat(0.0), CGFloat(1.0), CGFloat(0.0))
//                self.door.layer.transform = rotationAndPerspectiveTransform

/// Sets up anchor point on right side
//    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
//        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
//        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
//
//        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
//        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
//
//        var position = view.layer.position
//        position.x -= oldPoint.x
//        position.x += newPoint.x
//
//        position.y -= oldPoint.y
//        position.y += newPoint.y
//
//        view.layer.position = position
//        view.layer.anchorPoint = anchorPoint
//
//
//
//    func setAnchorPoint(anchorPoint: AnchorPoint) {
//        switch anchorPoint {
//        case .Top:
//
//        case .Right:
//
//        case .Bottom:
//
//        case .Left:
//
//        }
//    }



