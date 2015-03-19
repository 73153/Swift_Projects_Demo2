//
//  GameScene.swift
//  SpriteKitSimpleGame
//
//  Created by David Moles on 6/8/14.
//  Copyright (c) 2014 David Moles. All rights reserved.
//

import SpriteKit

@infix func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPointMake(left.x + right.x, left.y + right.y)
}

@infix func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPointMake(left.x - right.x, left.y - right.y)
}

@infix func *(left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPointMake(left.x * right, left.y * right)
}

extension CGPoint {
    func length() -> CGFloat {
        return sqrtf(self.x * self.x + self.y * self.y)
    }

    func normalize() -> CGPoint {
        let length = self.length()
        return CGPointMake(self.x / length, self.y / length)
    }
}


class GameScene: SKScene {
    
    let player: SKSpriteNode
    var lastSpawnTimeInterval: NSTimeInterval = 0
    var lastUpdateTimeInterval: NSTimeInterval = 0
    
    init(size: CGSize) {
        player = SKSpriteNode(imageNamed:"player")
        super.init(size: size)

        let x = player.size.width / 2
        let y = frame.size.height / 2
        player.position = CGPointMake(x, y)

        println("Size: \(NSStringFromCGSize(size))")
        
        backgroundColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        addChild(self.player)
    }

    func addMonster() {
        let monster = SKSpriteNode(imageNamed:"monster")
        let margin = Int(monster.size.height) / 2
        let minY = margin
        let maxY = Int(frame.size.height) - margin
        let rangeY = maxY - minY
        let yRandom = Int(arc4random_uniform(UInt32(rangeY)))
        let actualY = yRandom + minY

        let x = frame.size.width + monster.size.width / 2
        let y = CGFloat(actualY)

        monster.position = CGPointMake(x, y)
        addChild(monster)

        println("Added monster at \(x), \(y)")

        let minDuration = 2.0
        let maxDuration = 4.0
        let rangeDuration = maxDuration - minDuration
        let actualDuration = (Double(arc4random()) % rangeDuration) + minDuration

        let location = CGPointMake(-monster.size.width / 2, y)
        let actionMove = SKAction.moveTo(location, duration: actualDuration)
        let actionMoveDone = SKAction.removeFromParent()

        monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }

    func spawn(timeSinceLast: CFTimeInterval) {
        lastSpawnTimeInterval += timeSinceLast
        if lastSpawnTimeInterval > 1 {
            lastSpawnTimeInterval = 0
            addMonster()
        }
    }

    override func update(currentTime: NSTimeInterval) {
        var timeSinceLast = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        if (timeSinceLast > 1) {
            timeSinceLast = 1.0 / 60.0
            lastUpdateTimeInterval = currentTime
        }
        spawn(timeSinceLast)
    }

    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        let touch = touches.anyObject()
        let location = touch.locationInNode(self)

        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position

        let offset = location - projectile.position

        if (offset.x > 0) {
            addChild(projectile)
            let direction = offset.normalize()
            let shootAmount = direction * 1000
            let realDest = shootAmount + projectile.position

            let velocity = CGFloat(480.0)
            let realMoveDuration = NSTimeInterval(size.width / velocity)

            let actionMove = SKAction.moveTo(realDest, duration: realMoveDuration)
            let actionMoveDone = SKAction.removeFromParent()

            projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        }
    }

//    override func didMoveToView(view: SKView) {
//        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
//    }
//    
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
//   
//    override func update(currentTime: CFTimeInterval) {
//        /* Called before each frame is rendered */
//    }
}
