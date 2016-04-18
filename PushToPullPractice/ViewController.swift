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
//            UIView.animateWithDuration(0.5, animations: {
//                self.currentDoorView.transform = CGAffineTransformIdentity
//            }) { (completed) in
//            }
            
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                self.currentDoorView.transform = CGAffineTransformIdentity
            }) { (completed) in
            }
        }
    }
    
    var nextDoorView: DoorView! {
        didSet {
            
        }
    }
    
    @IBOutlet var swipeRecognizers: [UISwipeGestureRecognizer]!
    var initialDoorViewFrame: CGRect = CGRect.zero
    var stage = Stage(numberOfDoors: 10)
    
    
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
        
        
        nextDoorView.frame = initialDoorViewFrame
        nextDoorView.delegate = self
        nextDoorView.addSublayers()
        nextDoorView.centerInSuperview()
        nextDoorView.scaleByFactor(0.25)
        self.view.insertSubview(nextDoorView, belowSubview: currentDoorView)
    }
    
    func configureNextDoorView() {
        
    }
    
    func addNextDoorView() {
        
        if let firstDoor = stage.doors.first {
            nextDoorView = DoorView(door: firstDoor)
            stage.doors.removeFirst()
            
        }
        
        guard nextDoorView != nil else {
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
            self.currentDoorView.open(withDuration: 0.5)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touches began")
    }
    
}

extension ViewController: DoorViewDelegate {
    func doorDidOpen(door: DoorView) {
        print("Door did open")
        
        currentDoorView = nextDoorView
        
        for recognizer in self.swipeRecognizers {
            currentDoorView.addGestureRecognizer(recognizer)
        }
        
        self.view.insertSubview(door, belowSubview: nextDoorView)
        
        addNextDoorView()
    }
    
    func didWalkThroughDoor(door: DoorView) {
        print("Did walk through door")
        removeOldDoorView(door)
    }
    
    func removeOldDoorView(oldView: DoorView) {
        oldView.delegate = nil
        oldView.removeFromSuperview()
        print("old view removed")
    }
    
    
}
