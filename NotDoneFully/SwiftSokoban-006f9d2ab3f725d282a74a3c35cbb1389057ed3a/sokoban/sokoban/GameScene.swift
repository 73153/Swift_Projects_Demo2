//
//  GameScene.swift
//  sokoban
//
//  Created by Admin on 06/06/14.
//  Copyright (c) 2014 dzamataev. All rights reserved.
//

import Foundation
import SpriteKit

let space = 100.0
// e : empty, w : wall, 
var levelData = [
    ["e","e","w","w","w","w","w","e"],
    ["w","w","w","e","e","e","w","e"],
    ["w","e","s","e","w","e","w","w"],
    ["w","e","w","e","e","h","e","w"],
    ["w","e","e","e","e","w","e","w"],
    ["w","w","s","w","h","e","e","w"],
    ["e","w","p","e","e","w","w","w"],
    ["e","w","w","w","w","w","e","e"]
]

class GameScene: SKScene {
    // properties initialization
    // note that the spriteNode property below is not initialized
    // we initialize it through the init initializer below
    var playerNode = SKSpriteNode()
    var levelNodes = SKSpriteNode[]()
    var osci = 0.0

    
    override func didMoveToView(view: SKView) {
        var dx = 0.0
        var dy = 0.0
        for line in levelData {
            for symbol in line {
                var entity: NSString
                switch symbol {
                case "e":
                    entity = "empty"
                case "w":
                    entity = "wall"
                case "s":
                    entity = "stone"
                case "h":
                    entity = "hole"
                case "p":
                    entity = "player"
                default:
                    entity = ""
                }
                var propSprite = SKSpriteNode(imageNamed:"\(entity)")
                propSprite.anchorPoint = CGPoint(x: 0, y: 0)
                propSprite.position = CGPoint(x: CGFloat(dx), y: CGFloat(dy))
                levelNodes.append(propSprite)
                dx += space
            }
            dy += space
            dx = 0
        }
        
        for prop in levelNodes {
            self.addChild(prop)
        }
    }
    
    
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        /* Called when a touch begins */
//        
//        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
//    }
   
    override func update(currentTime: CFTimeInterval) {
//        didMoveToView(self.view);
        /* Called before each frame is rendered */
    }
}
