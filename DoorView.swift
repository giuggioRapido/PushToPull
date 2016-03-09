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

class DoorView: UIView {
    var handlePosition: HandlePosition
    var door: Door
    var delegate: DoorViewDelegate?
    
    
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
    func createDoorFrameLayer() {
        let frameLayer = CALayer()
        frameLayer.borderWidth = 10
        frameLayer.frame = self.bounds
        frameLayer.delegate = self
        self.layer.addSublayer(frameLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let config = DoorLogicConfigurator()
        let preconfigDoor = SlidingDoor(handlePosition: .Left, configurer: config)
        let configuredDoor = config.configureSlidingDoor(preconfigDoor)
        door = configuredDoor
        self.handlePosition = door.handlePosition
        
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        let config = DoorLogicConfigurator()
        let preconfigDoor = SlidingDoor(handlePosition: .Left, configurer: config)
        let configuredDoor = config.configureSlidingDoor(preconfigDoor)
        door = configuredDoor
        self.handlePosition = door.handlePosition
        
        super.init(frame: frame)
    }
    
    convenience init(handlePosition: HandlePosition, frame: CGRect = CGRect.zero) {
        self.init(frame: frame)
        self.handlePosition = door.handlePosition
    }
    
    
    func open(swipeDirection: UISwipeGestureRecognizerDirection) {
        func slideOpenUp() {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.layer.frame.size.height = 0
                }) { (completed) -> Void in
                    if (completed) {
                        self.delegate?.doorDidOpen(self)
                    }
            }
        }
        
        func slideOpenRight() {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.frame.origin.x = self.frame.maxX
                self.frame.size.width = 0
                }) { (completed) -> Void in
                    self.delegate?.doorDidOpen(self)
            }
        }
        
        func slideOpenDown() {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.frame.origin.y = self.frame.maxY
                self.frame.size.height = 0
                }) { (completed) -> Void in
                    self.delegate?.doorDidOpen(self)
            }
            
        }
        
        func slideOpenLeft() {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.frame.size.width = 0
                }) { (completed) -> Void in
                    self.delegate?.doorDidOpen(self)
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
    
    
    
    
    func close(direction: SlideDirection) {
        
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
    //    }
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
