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
            UIView.animateWithDuration(1.0, animations: {
                self.currentDoorView.transform = CGAffineTransformIdentity
            }) { (completed) in
            }
        }
    }
    var nextDoorView: DoorView? {
        didSet {
            
        }
    }
    var initialDoorViewFrame: CGRect = CGRect.zero
    var stage = Stage(numberOfDoors: 50)
    
    @IBOutlet var swipeRecognizers: [UISwipeGestureRecognizer]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// assign stage's first door to currentDoorView:
        guard stage.doors.count > 0 else {
            print("stage has no doors")
            return
        }
        currentDoorView.door = stage.doors.first!
        stage.doors.removeFirst()
        
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
        
        guard nextDoorView != nil else {
            return
        }
        nextDoorView?.frame = initialDoorViewFrame
        nextDoorView?.delegate = self
        nextDoorView?.addSublayers()
        nextDoorView!.centerInSuperview()
        nextDoorView!.scaleByFactor(0.25)
        self.view.insertSubview(nextDoorView!, belowSubview: currentDoorView)
    }
    
    func configureNextDoorView() {
        
    }
    
    func addNextDoorView(oldDoor: DoorView) {
        
        if let firstDoor = stage.doors.first {
            nextDoorView = DoorView(door: firstDoor)
            stage.doors.removeFirst()
            
        }
        
        guard nextDoorView != nil else {
            return
        }
        
        nextDoorView!.frame = currentDoorView.frame
        nextDoorView?.delegate = self
        nextDoorView?.addSublayers()
        nextDoorView!.centerInSuperview()
        nextDoorView!.scaleByFactor(0.25)
        
        self.view.insertSubview(nextDoorView!, belowSubview: currentDoorView)
    }
    
    @IBAction func swipe(sender: UISwipeGestureRecognizer) {
        if (sender.direction.rawValue ==  currentDoorView.door.swipeDirection.rawValue) {
            self.currentDoorView.open()
            print(currentDoorView.gestureRecognizers!.count)
        }
    }
}

extension ViewController: DoorViewDelegate {
    func doorDidOpen(door: DoorView) {
        print("Door did open")
        currentDoorView = nextDoorView
        for recognizer in self.swipeRecognizers {
            currentDoorView.addGestureRecognizer(recognizer)
        }
        addNextDoorView(door)
    }
    
    func didWalkThroughDoor(door: DoorView) {
        print("Did walk through door")
        removeOldDoorView(door)
    }
    
    func removeOldDoorView(oldView: DoorView) {
        oldView.delegate = nil
        oldView.removeFromSuperview()
        
    }
    
    
}
