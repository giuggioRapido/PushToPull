//
//  DoorView.swift
//  PushToPullPractice
//
//  Created by Chris on 3/4/16.
//  Copyright © 2016 Prince Fungus. All rights reserved.
//

import UIKit

protocol DoorViewDelegate {
    func doorDidOpen(door: DoorView?)
}

class DoorView: UIView {
    var door: Door
    var delegate: DoorViewDelegate?
    var doorLayer = CALayer()
    var frameLayer = CALayer()
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    // MARK: Initialization
    
    enum AnchorPoint {
        case Top
        case Right
        case Bottom
        case Left
    }
    
    // FIXME: Get the layer created within the class. Currently method is being called in VC
    func createSubLayers() {
        doorLayer.frame = self.bounds
        doorLayer.backgroundColor = UIColor.whiteColor().CGColor
        doorLayer.delegate = self
        self.layer.addSublayer(doorLayer)
        
        frameLayer.borderWidth = 10
        frameLayer.frame = self.bounds
        frameLayer.delegate = self
        self.layer.addSublayer(frameLayer)
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
                    if (completed) {
                        self.delegate?.doorDidOpen(self)
                    }
            }
        }
        
        func slideOpenRight() {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.doorLayer.frame.origin.x = self.doorLayer.frame.maxX
                self.doorLayer.frame.size.width = 0
                }) { (completed) -> Void in
                    self.delegate?.doorDidOpen(self)
            }
        }
        
        func slideOpenDown() {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.doorLayer.frame.origin.y = self.doorLayer.frame.maxY
                self.doorLayer.frame.size.height = 0
                }) { (completed) -> Void in
                    self.delegate?.doorDidOpen(self)
            }
            
        }
        
        func slideOpenLeft() {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.doorLayer.frame.size.width = 0
                }) { (completed) -> Void in
                    self.delegate?.doorDidOpen(nil)
            }
        }
        
        
        switch swipeDirection {
        case UISwipeGestureRecognizerDirection.Up:
            slideOpenUp()
        case UISwipeGestureRecognizerDirection.Right:
            slideOpenRight()
        case UISwipeGestureRecognizerDirection.Down:
            slideOpenDown()
        case UISwipeGestureRecognizerDirection.Left:
            slideOpenLeft()
        default:
            print("Gesture not recognized: \(swipeDirection)")
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
    
    
}
