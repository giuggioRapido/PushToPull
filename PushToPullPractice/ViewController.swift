//
//  ViewController.swift
//  PushToPullPractice
//
//  Created by Chris on 2/28/16.
//  Copyright © 2016 Prince Fungus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currentDoor: DoorView!
    var initialDoorPosition: CGRect = CGRect.zero
    var doorframe = CALayer()
    var initialDoorFrame =  CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        currentDoor.delegate = self
        currentDoor.addSublayers()
    }
    
    
    
    @IBAction func swipe(sender: UISwipeGestureRecognizer) {
        if (sender.direction.rawValue ==  currentDoor.door.swipeDirection.rawValue) {
            self.currentDoor.open(sender.direction)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: DoorViewDelegate {
    func doorDidOpen(door: DoorView) {
        /// DoorView's openingLayer has completed its open animation,
        print("Door did open")
    }
}
