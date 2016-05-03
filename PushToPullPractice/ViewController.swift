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
            scaleUpDoorView(currentDoorView, withDuration: stage.doorOpenDuration)
        }
    }
    
    var nextDoorView: DoorView!
    
    @IBOutlet var swipeRecognizers: [UISwipeGestureRecognizer]!
    var stage = Stage(numberOfDoors: 10, ofType: DoorType.Sliding)
    
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
        
        nextDoorView.frame = currentDoorView.frame
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
        
        if (sender.direction.rawValue ==  currentDoorView.door.swipeDirection.rawValue) {
            /// If the door is currently animating, we grab the backround color at the moment of the correct swipe from the presentation layer. We set the model layer's bg color to match.
            /// This allows us to freeze the color at the right moment, then in the CATransaction's
            /// completion handler, check that color against the target color.
            /// This is how we test for SUCCESSFUL completion of the animation (e.g. the door turns full red)
            /// rather than "failure" (the door is opened before full red is reached). CATransactions seem
            /// to lack this functionality, unlike UIViews where the completion block has an associated Bool.
            if let pl = currentDoorView.openingLayer.presentationLayer() {
                currentDoorView.openingLayer.backgroundColor = pl.backgroundColor
            } else {
                print("currentDoorView.openingLayer.presentationLayer() returned nil")
            }
            
            self.currentDoorView.open(withDuration: stage.doorOpenDuration)
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
    
    func scaleUpDoorView(view: DoorView, withDuration duration: Double) {
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            view.transform = CGAffineTransformIdentity
        }) { (completed) in
        }
    }
    
    func beginTimer() {
        
        let targetColor = UIColor.init(red: 235.0/255, green: 50.0/255, blue: 50.0/255, alpha: 1.0).CGColor
        
        let countDown = {
            (completion:(() -> ())?) in
            CATransaction.begin()
            CATransaction.setAnimationDuration(self.stage.timeLimit)
            CATransaction.setCompletionBlock(completion)
            self.currentDoorView.openingLayer.backgroundColor = targetColor
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn))
            CATransaction.commit()
        }
        
        countDown {
            let currentColor = self.currentDoorView.openingLayer.backgroundColor
            let colorsEqual = CGColorEqualToColor(currentColor, targetColor)
            if (colorsEqual) {
                self.presentGameOverAlert()
            }
        }
    }
    
    func presentGameOverAlert() {
        let alert = UIAlertController.init(title: "Dead.", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: DoorViewDelegate {
    
    func doorDidOpen(door: DoorView) {
        door.walkThroughDoor(stage.doorOpenDuration)
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
