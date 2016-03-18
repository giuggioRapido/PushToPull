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
    /// A DoorView has four layers: the default superlayer it comes with;
    /// a sublayer called openingLayer, which represents "actual" door;
    /// a sublayer called baseLayer for the doorframe and provides a mask for the door;
    /// and a sublayer handleLayer for the door handle.
    /// Separating these views into separate layers allows for custom animations to applied to each
    var openingLayer = CALayer()
    var baseLayer = CALayer()
    var handleLayer = CALayer()
    
    
    
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
    func addSublayers() {
        openingLayer.frame = self.bounds
        openingLayer.backgroundColor = UIColor.whiteColor().CGColor
        
        baseLayer.borderWidth = 10
        baseLayer.frame = self.bounds
        baseLayer.masksToBounds = true
        
        handleLayer.frame = CGRectMake(20, 200, 10, 30)
        handleLayer.backgroundColor = UIColor.blueColor().CGColor
        
        openingLayer.addSublayer(handleLayer)
        baseLayer.addSublayer(openingLayer)
        self.layer.addSublayer(baseLayer)
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
    
    
    func open(swipeDirection: UISwipeGestureRecognizerDirection, duration: CFTimeInterval = 1.0) {
        
        /// We only slideOpen if switch statement below determines self.door is Sliding,
        /// so we downcast as SlidingDoor so we can switch on door.slideDirection.
        /// For each slideDirection case, a different translation is created, 
        /// which is then passed into the slideAnimation below. 
        func slideOpen() {
            
            let slidingDoor = self.door as! SlidingDoor
            let translation: CATransform3D
            
            switch slidingDoor.slideDirection {
            case .Down:
                let height = baseLayer.bounds.height
                translation = CATransform3DMakeTranslation(0, height, 0)
            case .Left:
                let width = openingLayer.bounds.size.width
                translation = CATransform3DMakeTranslation(-width, 0, 0)
            case .Right:
                let width = openingLayer.bounds.size.width
                translation = CATransform3DMakeTranslation(width, 0, 0)
            case .Up:
                let height = baseLayer.bounds.height
                translation = CATransform3DMakeTranslation(0, -height, 0)
            }
            
            let slideAnimation = {
                (completion:(() -> ())?) in
                CATransaction.begin()
                CATransaction.setCompletionBlock(completion)
                CATransaction.setAnimationDuration(duration)
                self.openingLayer.transform = translation
                CATransaction.commit()
            }
            slideAnimation({self.walkThroughDoor()})
        }
        
        switch self.door {
        case is Sliding:
            slideOpen()
        default:
            print("is not sliding")
        }
    }
    
    func walkThroughDoor() {
        let scaleAnimation = {
            (completion:(() -> ())?) in
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            CATransaction.setAnimationDuration(1.0)
            self.baseLayer.transform = CATransform3DMakeScale(3.0, 3.0, 2.0)
            CATransaction.commit()
        }
        scaleAnimation(nil)
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



