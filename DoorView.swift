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
    func didWalkThroughDoor(door: DoorView)
}

@IBDesignable class DoorView: UIView {
    /// Each DoorView is backed by a Door-type instance.
    /// the backing door's properties are used to configure a DoorView.
    var door: Door
    var delegate: DoorViewDelegate?
    /// A DoorView has three sublayers:
    ////a sublayer called openingLayer, which represents "actual" door;
    /// a sublayer called baseLayer for the doorframe and provides a mask for the door;
    /// and a sublayer handleLayer for the door handle.
    /// Separating these views into separate layers allows for custom animations to applied to each
    var openingLayer = CALayer()
    var baseLayer = CALayer()
    var handleLayer = CALayer()
    
    /// Describes possible locations for the anchorpoint corresponding
    /// to actual coordinates, for use with certain door types (e.g. hinged).
    enum AnchorPoint {
        case Top
        case Right
        case Bottom
        case Left
    }
    
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        let preconfigDoor = SlidingDoor(handlePosition: .Left)
        let configuredDoor = DoorLogicConfigurer.configureSlidingDoor(preconfigDoor)
        door = configuredDoor
        
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        let preconfigDoor = SlidingDoor(handlePosition: .Left)
        let configuredDoor = DoorLogicConfigurer.configureSlidingDoor(preconfigDoor)
        door = configuredDoor
        
        super.init(frame: frame)
    }
    
    convenience init(door: Door, frame: CGRect = CGRect.zero) {
        self.init(frame: frame)
        self.door = door
    }
    
    // FIXME: Get the layers added within the class (within/after init). Currently method is being called in VC
    func addSublayers() {
        /// baseLayer ends up looking like a door frame
        baseLayer.borderWidth = 10
        baseLayer.frame = self.bounds
        baseLayer.masksToBounds = true
        
        /// openingLayer is the part of the door that opens
        openingLayer.frame = self.bounds
        openingLayer.backgroundColor = UIColor.whiteColor().CGColor
        
        /// handleLayer has several possble positions
        /// width and height are given assuming handle is vertical (i.e. skinny and tall, as if on left)
        let handleFrame: CGRect
        let handlePosition: CGPoint
        let width: CGFloat = 10
        let height: CGFloat = 30
        let doorMidX = baseLayer.bounds.midX
        let doorMaxX = baseLayer.bounds.maxX
        let doorMidY = baseLayer.bounds.midY
        let doorMaxY = baseLayer.bounds.maxY
        let inset: CGFloat = 30

        switch self.door.handlePosition {
        case .Bottom:
            handlePosition = CGPointMake(doorMidX, doorMaxY - inset)
            handleLayer.bounds.size.width = height
            handleLayer.bounds.size.height = width
        case .Left:
            handlePosition = CGPointMake(inset, doorMidY - inset)
            handleLayer.bounds.size.width = width
            handleLayer.bounds.size.height = height

        case .Right:
            handlePosition = CGPointMake(doorMaxX - inset, doorMidY)
            handleLayer.bounds.size.width = width
            handleLayer.bounds.size.height = height

        case .Top:
            handlePosition = CGPointMake(doorMidX, inset - inset)
            handleLayer.bounds.size.width = height
            handleLayer.bounds.size.height = width
        }
        
        handleLayer.anchorPoint = CGPointMake(0.5, 0.5)
        handleLayer.position = handlePosition
        handleLayer.backgroundColor = UIColor.blueColor().CGColor
        
        /// Construct layer hierarchy
        openingLayer.addSublayer(handleLayer)
        baseLayer.addSublayer(openingLayer)
        self.layer.addSublayer(baseLayer)
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



