//
//  Grid.swift
//  Mario Memory Challenge
//
//  Created by Strickland, Keith on 6/4/14.
//  Copyright (c) 2014 Strickland, Keith. All rights reserved.
//

import Foundation

struct GridPoint: Equatable, Hashable {
    var x = 0
    var y = 0
    var hashValue: Int { return (x + y) * (x + y + 1) / 2 + x }
}

func ==(lhs: GridPoint, rhs: GridPoint) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

class GridObject {
    
}

class Grid {
    
    var gridMap: Dictionary<GridPoint, GridObject>
    var nilObject: GridObject
    
    init(nilObject: GridObject) {
        self.gridMap = Dictionary<GridPoint, GridObject>()
        self.nilObject = nilObject
    }
    
    func assignToPoint(point: GridPoint, object: GridObject) {
        gridMap[point] = object
    }
    
    func removeFromPoint(point: GridPoint) -> GridObject {
        if let returnVal = gridMap.removeValueForKey(point){
            return returnVal
        } else {
            return nilObject
        }
    }
    
    func objectAtPoint(point: GridPoint) -> GridObject {
        if let val = gridMap[point]{
            return val
        } else {
            return nilObject
        }
    }
    
    func clear() {
        gridMap.removeAll(keepCapacity: true)
    }
    
}
