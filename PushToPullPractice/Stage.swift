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
            let handlePosition = HandlePosition(rawValue: randomHandle)
            guard let hp = handlePosition else {
                let door = SlidingDoor(handlePosition: .Left)
                arrayOfDoors.append(door)
                continue
            }
            let door = SlidingDoor(handlePosition: hp)
            arrayOfDoors.append(door)
        }
        return arrayOfDoors
    }
    
    
    init(numberOfDoors: Int) {
        doors = Stage.generateRandomSlidingDoors(numberOfDoors)
        
    }
}