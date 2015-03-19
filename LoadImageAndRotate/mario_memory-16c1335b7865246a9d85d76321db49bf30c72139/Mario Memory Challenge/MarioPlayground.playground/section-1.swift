// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

struct GridPoint: Equatable, Hashable {
    var x = 0
    var y = 0
    var hashValue: Int { return (x + y) * (x + y + 1) / 2 + x }
}

func ==(lhs: GridPoint, rhs: GridPoint) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

let gp = GridPoint(x: 1, y: 11)
gp.hashValue

let gp2 = GridPoint(x: 11, y: 1)
gp2.hashValue

let gp3 = GridPoint()
gp3.hashValue

let gp4 = GridPoint(x: 32, y: 32)
gp4.hashValue

struct GameObject {
    var id  = "Mario"
}

let nilGameObject = GameObject(id: "nilObject")





















