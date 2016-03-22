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
/// The following enums are used to describe properties of Door-related types

/// HandlePosition describes the location of a door's handle. This corresponds
/// to a subview of DoorView. The HandlePosition is also used to configure the
/// rest of the door's functionality (the enums that follow), as implemented
/// in DoorLogicConfigurer.
enum HandlePosition: UInt32 {
    case Top, Right, Bottom, Left
}


/// Describes the location of a hinge on a door. It will ultimately be used to determine
/// the achor point of a CALayer for use in DoorView animation.
enum HingePosition {
    case Top, Right, Bottom, Left
}

/// Describes the direction in which a sliding door opens, for use with
/// a DoorView animation.
enum SlideDirection {
    case Up, Right, Down, Left
}

/// Describes the swipe gesture required to open a given door.
/// Has raw value of UInt corresponding with UISwipeGestureRecognizerDirection
enum SwipeDirection: UInt {
    case Right = 1
    case Left = 2
    case Up = 4
    case Down = 8
}

/// Describes the the area of a door where the opening gesure must be located.
/// This is only relevant for certain door types.
enum GestureZone {
    case Top, Right, Bottom, Left
}

// Mark: Protocols
protocol Door {
    var handlePosition: HandlePosition {get set}
    var swipeDirection: SwipeDirection {get set}
    
    func open()
}

protocol Sliding {
    var slideDirection: SlideDirection {get set}
}

protocol ConfiguresDoors {
    static func configureSlidingDoor(door: protocol <Door, Sliding>) -> protocol <Door, Sliding>
}

// Mark: Protocol Extensions
extension Door where Self: Sliding {
    
    func open() {
    }
    
    func close()  {
    }
}


// Mark: Structs
struct DoorLogicConfigurer: ConfiguresDoors {
    /// Takes a sliding door instance as a parameter and switches on the door's handle position.
    /// Returns an instance of a door with properties populated by configured values.
   static func configureSlidingDoor(door: protocol <Door, Sliding>) -> protocol <Door, Sliding> {
    
        var configDoor = SlidingDoor(handlePosition: door.handlePosition)
    
        switch door.handlePosition {
            
        case .Top:
            configDoor.slideDirection = .Down
            configDoor.swipeDirection = .Up
            
        case .Right:
            configDoor.slideDirection = .Left
            configDoor.swipeDirection = .Right
            
        case .Bottom:
            configDoor.slideDirection = .Up
            configDoor.swipeDirection = .Down
            
        case .Left:
            configDoor.slideDirection = .Right
            configDoor.swipeDirection = .Left
        }
        return configDoor
    }
    
    /// Similarly in fucntion to the method above, but instead takes only a HandlePosition value as
    /// a parameter and returns a tuple of the configured values for other door properties.
    func configureSlidingLogicForHandlePosition(handlePosition: HandlePosition) -> (slideDirection: SlideDirection, swipeDirection: SwipeDirection) {
        
        switch handlePosition {
            
        case .Top:
            return(.Down, .Up)
            
        case .Right:
            return(.Left, .Right)
            
        case .Bottom:
            return(.Up, .Down)
            
        case .Left:
            return(.Right, .Left)
        }
    }
}

struct SlidingDoor: Door, Sliding {
    var handlePosition: HandlePosition
    var slideDirection: SlideDirection
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





