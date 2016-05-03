//
//  Stage.swift
//  PushToPullPractice
//
//  Created by Chris on 3/21/16.
//  Copyright © 2016 Prince Fungus. All rights reserved.
//

import Foundation

enum DoorType {
    case Sliding
    case Hinged
}

struct Stage {
    var doors: [Door]
    var timeLimit: Double = 1.0
    var doorOpenDuration: Double = 0.51
    
    private static func generateRandomSlidingDoors(doorCount: Int) -> [Door] {
        var arrayOfDoors: [Door] = []
        
        for _ in 0..<doorCount {
            let randomHandle = arc4random_uniform(4)
            let handlePosition = HandlePosition(rawValue: randomHandle) ?? .Left
            let door = SlidingDoor(handlePosition: handlePosition)
            arrayOfDoors.append(door)
        }
        return arrayOfDoors
    }
    
    private static func generateRandomHingedDoors(doorCount: Int) -> [Door] {
        var arrayOfDoors: [Door] = []
        
        for _ in 0..<doorCount {
            let randomHandle = arc4random_uniform(4)
            let randomPushOrPull = arc4random_uniform(2)
            let handlePosition = HandlePosition(rawValue: randomHandle) ?? .Left
            let pushOrPull = PushOrPull(rawValue: randomPushOrPull) ?? .Pull
        
            let door = HingedDoor(handlePosition: handlePosition, pushOrPull: pushOrPull)
            arrayOfDoors.append(door)
        }
        return arrayOfDoors
        
    }
    
    init(numberOfDoors: Int, ofType type: DoorType) {
        switch type {
        case .Sliding:
            doors = Stage.generateRandomSlidingDoors(numberOfDoors)
        case .Hinged:
            doors = Stage.generateRandomHingedDoors(numberOfDoors)
        }
    }
}