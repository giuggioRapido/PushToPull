//
//  ViewController.swift
//  PushToPullPractice
//
//  Created by Chris on 2/28/16.
//  Copyright © 2016 Prince Fungus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var door: DoorView!
    var initialDoorPosition: CGRect = CGRect.zero
    var doorframe = CALayer()
    var initialDoorFrame =  CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        door.delegate = self
        
        door.createSubLayers()
    }
    
    
    
    @IBAction func swipe(sender: UISwipeGestureRecognizer) {
        print(door.door.swipeDirection)
        print(sender.direction)
        
        if (sender.direction.rawValue ==  door.door.swipeDirection.rawValue) {
            self.door.open(sender.direction)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: DoorViewDelegate {
    func doorDidOpen(door: DoorView) {
        /// DoorView's doorLayer has completed its open animation,
        print("Door did open")
    }
}
