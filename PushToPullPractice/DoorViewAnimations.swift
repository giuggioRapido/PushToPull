//
//  DoorViewAnimations.swift
//  PushToPullPractice
//
//  Created by Chris on 3/23/16.
//  Copyright © 2016 Prince Fungus. All rights reserved.
//

import Foundation
import UIKit

extension DoorView {
    func open(withDuration duration: CFTimeInterval = 1.0) {
        
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
            
            /// Actual call to slideAnimation closure.
            /// Upon completion, notify delegate and call walkThroughDoor()
            slideAnimation({
                self.delegate?.doorDidOpen(self)
                self.walkThroughDoor()
            })
        }
        
        /// Switch to determine door type, and thus appropriate opening animation.
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
        scaleAnimation({
            self.delegate?.didWalkThroughDoor(self)
        })
    }
 
}