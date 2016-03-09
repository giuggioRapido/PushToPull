//
//  Door.swift
//  PushToPullPractice
//
//  Created by Chris on 3/3/16.
//  Copyright © 2016 Prince Fungus. All rights reserved.
//

import Foundation

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

enum SwipeDirection {
    case Up, Right, Down, Left
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
    func close()
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
        print("Door slid \(slideDirection) to open")
    }
    
    func close()  {
        print("Door closed")
    }
}

// Mark: Structs

struct DoorLogicConfigurator: ConfiguresDoors {
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
}

struct SlidingDoor: Door, Sliding {
    var handlePosition = HandlePosition.Left
    var slideDirection = SlideDirection.Right
    var implicitInstruction = ImplicitInstruction.Slide
    var swipeDirection = SwipeDirection.Left
    
    init(handlePosition: HandlePosition, configurer: ConfiguresDoors) {
        self.handlePosition = handlePosition
        let configuredDoor = configurer.configureSlidingDoor(self)
        self.handlePosition = configuredDoor.handlePosition
        self.slideDirection = configuredDoor.slideDirection
        self.swipeDirection = configuredDoor.swipeDirection
    }
    
    func printDescription() {
        print("handlePosition: \(handlePosition), slideDirection: \(slideDirection), swipeDirection: \(swipeDirection)")
    }
}

let config = DoorLogicConfigurator()

let sd1 = SlidingDoor(handlePosition: .Left, configurer: config)
sd1.printDescription()

let sd2 = SlidingDoor(handlePosition: .Bottom, configurer: config)
sd2.printDescription()

let sd3 = SlidingDoor(handlePosition: .Right, configurer: config)
sd3.printDescription()

let sd4 = SlidingDoor(handlePosition: .Top, configurer: config)
sd4.printDescription()





//protocol Hinged {
//    //var hingePosition: HingePosition {get set}
//    var gestureZone: GestureZone {get set}
//}





