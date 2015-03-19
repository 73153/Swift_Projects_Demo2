//
//  Popcorn.swift
//  HPIANO
//
//  Created by Lukas Ingelheim on 04/06/2014.
//  Copyright (c) 2014 Lukas Ingelheim. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


class Popcorn:Sprite {
    let kinds = ["normal" : 1.0, "special" : 0.5, "super" : 0.2]
    let kind:String
    let xValue:CGFloat
    let parentFrame:CGRect
    
    init(kind: String, xValue:CGFloat, parentFrame:CGRect) {
//        parentFrame.minX
        
        self.kind = kind
        self.xValue = xValue
        self.parentFrame = parentFrame
        
        println("created a " + kind)

    }
    
    
    func calculateLocation() -> CGPoint{
      return CGPoint(x:xValue, y:CGRectGetMaxY(parentFrame));
    }
    
    
    func getSize() -> CGFloat {
        return CGFloat(kinds[kind]!)
    }
    
    func getSprite() -> SKSpriteNode {
        var size = getSize()
        let sprite = SKSpriteNode(imageNamed:"popcorn-1")
        sprite.xScale = size
        sprite.yScale = size
        sprite.position = calculateLocation()
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 2.0)
        sprite.physicsBody.mass = 2.0
        
        return sprite
    }
}

struct PopcornFactory {
    static let kinds = ["normal", "normal", "normal", "normal", "special", "special", "super"]
    
    static func createPopcorn(parentFrame:CGRect) -> Popcorn {
        
        var randomNumber:Int = Int(arc4random_uniform(7))
        var popcorn = Popcorn(kind: kinds[randomNumber], xValue: 500, parentFrame: parentFrame)
        return popcorn
    }
}