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
    var initialDoorPosition: CGRect = CGRect.zero
    var doorframe = CALayer()
    var initialDoorFrame =  CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        currentDoorView.delegate = self
        currentDoorView.addSublayers()
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
    }
}
