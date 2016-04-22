//
//  ViewController.swift
//  PushToPullPractice
//
//  Created by Chris on 2/28/16.
//  Copyright © 2016 Prince Fungus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currentDoorView: DoorView! {
        didSet {
            /// Whenever we set this, we assume it had been scaled down as nextDoorView,
            /// so we scale it back up to the original size.
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                self.currentDoorView.transform = CGAffineTransformIdentity
            }) { (completed) in
            }
        }
    }
    
    var nextDoorView: DoorView!
    
    @IBOutlet var swipeRecognizers: [UISwipeGestureRecognizer]!
    var initialDoorViewFrame: CGRect = CGRect.zero
    var stage = Stage(numberOfDoors: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Assign stage's first door to currentDoorView, then remove door from stage.
        guard stage.doors.count > 0 else {
            print("stage has no doors")
            return
        }
        currentDoorView.door = stage.doors.first!
        stage.doors.removeFirst()
        
        /// Assign the new first door to nextDoorView, then remove from stage.
        guard stage.doors.count > 0 else {
            print("stage has no doors")
            return
        }
        nextDoorView = DoorView(door: stage.doors.first!)
        stage.doors.removeFirst()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        currentDoorView.delegate = self
        currentDoorView.addSublayers()
        initialDoorViewFrame = currentDoorView.frame
        
        
        nextDoorView.frame = initialDoorViewFrame
        nextDoorView.delegate = self
        nextDoorView.addSublayers()
        nextDoorView.centerInSuperview()
        nextDoorView.scaleByFactor(0.25)
        self.view.insertSubview(nextDoorView, belowSubview: currentDoorView)
    }
    
    func addNextDoorView() {
        
        if let firstDoor = stage.doors.first {
            nextDoorView = DoorView(door: firstDoor)
            stage.doors.removeFirst()
        } else {
            return
        }
        
        nextDoorView.frame = currentDoorView.frame
        nextDoorView.delegate = self
        nextDoorView.addSublayers()
        nextDoorView.centerInSuperview()
        nextDoorView.scaleByFactor(0.25)
        self.view.insertSubview(nextDoorView, belowSubview: currentDoorView)
    }
    
    @IBAction func swipe(sender: UISwipeGestureRecognizer) {
        if let pl = currentDoorView.openingLayer.presentationLayer() {
            currentDoorView.openingLayer.backgroundColor = pl.backgroundColor
            //currentDoorView.openingLayer.removeAllAnimations()
            
        } else {
            print("else block hit")
        }
        
        
        if (sender.direction.rawValue ==  currentDoorView.door.swipeDirection.rawValue) {
            self.currentDoorView.open(withDuration: 0.5)
        }
    }
    
    func updateDoors() {
        currentDoorView = nextDoorView
        
        for recognizer in self.swipeRecognizers {
            currentDoorView.addGestureRecognizer(recognizer)
        }
        
        addNextDoorView()
        beginTimer()
    }
    
    func beginTimer() {
        
        let countDown = {
            (completion:(() -> ())?) in
            CATransaction.begin()
            CATransaction.setAnimationDuration(self.stage.timeLimit)
            let targetColor = UIColor.init(red: 235.0/255, green: 50.0/255, blue: 50.0/255, alpha: 1.0)
            self.currentDoorView.openingLayer.backgroundColor = targetColor.CGColor
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear))
            CATransaction.commit()
        }
        
        countDown {
            let currentColor = self.currentDoorView.openingLayer.backgroundColor
            let targetColor = UIColor.init(red: 235.0/255, green: 50.0/255, blue: 50.0/255, alpha: 1.0).CGColor
            let colorsEqual = CGColorEqualToColor(currentColor, targetColor)
            if (colorsEqual) {
                let alert = UIAlertController.init(title: "Dead", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    
}

extension ViewController: DoorViewDelegate {
    
    func doorDidOpen(door: DoorView) {
        self.view.sendSubviewToBack(door)
        updateDoors()
    }
    
    func didWalkThroughDoor(door: DoorView) {
        removeOldDoorView(door)
    }
    
    func removeOldDoorView(oldView: DoorView) {
        oldView.delegate = nil
        oldView.removeFromSuperview()
    }
    
    
}
