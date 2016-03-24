//
//  ViewController.swift
//  PushToPullPractice
//
//  Created by Chris on 2/28/16.
//  Copyright © 2016 Prince Fungus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currentDoorView: DoorView!
    var nextDoorView: DoorView?
    var initialDoorViewFrame: CGRect = CGRect.zero
    var stage = Stage(numberOfDoors: 10)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// assign stage's first door to currentDoorView:
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        currentDoorView.delegate = self
        currentDoorView.addSublayers()
        initialDoorViewFrame = currentDoorView.frame
        addNextDoorView()
    }
    
    func addNextDoorView() {
        
        if let firstDoor = stage.doors.first {
            nextDoorView = DoorView(door: firstDoor)
        }
        stage.doors.removeFirst()
        
        guard nextDoorView != nil else {
            return
        }
        
        nextDoorView!.frame = currentDoorView.frame
        nextDoorView?.addSublayers()
        nextDoorView!.center = self.view.center
        nextDoorView!.transform = CGAffineTransformMakeScale(0.25, 0.25)
        
        
        self.view.insertSubview(nextDoorView!, belowSubview: currentDoorView)
    }
    
    func scaleUpNextDoor() {
        UIView.animateWithDuration(1.0) {
            self.nextDoorView?.transform = CGAffineTransformIdentity
            
        }
    }
    
    
    @IBAction func swipe(sender: UISwipeGestureRecognizer) {
        if (sender.direction.rawValue ==  currentDoorView.door.swipeDirection.rawValue) {
            self.currentDoorView.open()
        }
    }
}

extension ViewController: DoorViewDelegate {
    func doorDidOpen(door: DoorView) {
        /// DoorView's openingLayer has completed its open animation,
        print("Door did open")
        scaleUpNextDoor()
    }
    
    func didWalkThroughDoor(door: DoorView) {
        print("Did walk through door")
    }
}
