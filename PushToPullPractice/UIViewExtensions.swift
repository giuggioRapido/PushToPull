//
//  UIViewExtensions.swift
//  PushToPullPractice
//
//  Created by Chris on 3/29/16.
//  Copyright © 2016 Prince Fungus. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func scaleByFactor(factor: CGFloat) {
        self.transform = CGAffineTransformMakeScale(factor, factor)
    }
    
    func centerInSuperview() {
        if let superview = self.superview {
            self.center = superview.center
        }
    }
}