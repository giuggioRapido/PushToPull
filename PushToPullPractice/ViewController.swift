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
    
    func walkThroughDoor() {
        /// We use inset to compensate for the doorframe's border thickness. In the case of a 10 pt border, we make the doorframe the size of the superview + 10 pts on each side, else we'll still see the border when animation is complete.
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            
//            self.door.layer.sublayers?.first?.bounds = CGRectInset(self.view.frame, -10, -10)
            self.door.layer.sublayers?[1].bounds = CGRectInset(self.view.frame, -10, -10)
           
            }) { (completed) -> Void in
                
                //self.door.removeFromSuperview()
        }
        
    }
    
    @IBAction func swipe(sender: UISwipeGestureRecognizer) {
        self.door.open(sender.direction)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController: DoorViewDelegate {
    func doorDidOpen(door: DoorView?) {
        print("Door did open")
        walkThroughDoor()
    }
}
