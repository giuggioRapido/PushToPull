//
//  Door.swift
//  PushToPullPractice
//
//  Created by Chris on 3/3/16.
//  Copyright © 2016 Prince Fungus. All rights reserved.
//

import Foundation
import UIKit

// MARK: Enums

enum HingePosition {
    case Top, Right, Bottom, Left
}

enum SlideDirection {
    case Up, Right, Down, Left
}

enum HandlePosition {
    case Top, Right, Bottom, Left
}

enum SwipeDirection: UInt {
    case Right, Left, Up, Down
}

enum GestureZone {
    case Top, Right, Bottom, Left
}

enum ImplicitInstruction {
    //    case Push, Pull
    case Slide
}

// Mark: Protocols

protocol Door {
    var handlePosition: HandlePosition {get set}
    var swipeDirection: SwipeDirection {get set}
    //    var implicitInstruction: ImplicitInstruction {get}
    
    func open()
}

protocol Sliding {
    var slideDirection: SlideDirection {get set}
}

protocol ConfiguresDoors {
    func configureSlidingDoor(door: protocol <Door, Sliding>) -> protocol <Door, Sliding>
}

// Mark: Protocol Extensions

extension Door where Self: Sliding {
    
    func open() {
    }
    
    func close()  {
        print("Door closed")
    }
}

// Mark: Structs

struct DoorLogicConfigurer: ConfiguresDoors {
    func configureSlidingDoor(var door: protocol <Door, Sliding>) -> protocol <Door, Sliding> {
        switch door.handlePosition {
            
        case .Top:
            door.slideDirection = .Down
            door.swipeDirection = .Up
            
        case .Right:
            door.slideDirection = .Left
            door.swipeDirection = .Right
            
        case .Bottom:
            door.slideDirection = .Up
            door.swipeDirection = .Down
            
        case .Left:
            door.slideDirection = .Right
            door.swipeDirection = .Left
        }
        return door
    }
    
    func configureSlidingLogicForHandlePosition(handlePosition: HandlePosition) -> (slideDirection: SlideDirection, swipeDirection: SwipeDirection) {
        // var door = SlidingDoor(handlePosition: handlePosition)
        
        switch handlePosition {
            
        case .Top:
            //            door.slideDirection = .Down
            //            door.swipeDirection = .Up
            return(.Down, .Up)
            
        case .Right:
            //            door.slideDirection = .Left
            //            door.swipeDirection = .Right
            return(.Left, .Right)
            
        case .Bottom:
            //            door.slideDirection = .Up
            //            door.swipeDirection = .Down
            return(.Up, .Down)
            
        case .Left:
            //            door.slideDirection = .Right
            //            door.swipeDirection = .Left
            return(.Right, .Left)
        }
        
        
    }
}

struct SlidingDoor: Door, Sliding {
    var handlePosition: HandlePosition
    var slideDirection: SlideDirection
    var implicitInstruction: ImplicitInstruction = ImplicitInstruction.Slide
    var swipeDirection: SwipeDirection
    
    init(handlePosition: HandlePosition) {
        self.handlePosition = handlePosition
        let configurer = DoorLogicConfigurer()
        let configuration = configurer.configureSlidingLogicForHandlePosition(handlePosition)
        self.slideDirection = configuration.slideDirection
        self.swipeDirection = configuration.swipeDirection
    }
    
    func printDescription() {
        print("handlePosition: \(handlePosition), slideDirection: \(slideDirection), swipeDirection: \(swipeDirection)")
    }
}




//protocol Hinged {
//    //var hingePosition: HingePosition {get set}
//    var gestureZone: GestureZone {get set}
//}





