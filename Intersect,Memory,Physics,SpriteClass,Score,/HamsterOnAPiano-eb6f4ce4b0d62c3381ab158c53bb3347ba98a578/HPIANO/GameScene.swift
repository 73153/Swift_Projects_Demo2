//
//  GameScene.swift
//  HPIANO
//
//  Created by Lukas Ingelheim on 04/06/2014.
//  Copyright (c) 2014 Lukas Ingelheim. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var test:SKSpriteNode[] = []
    var hamster:SKSpriteNode = SKSpriteNode()
    var currentTimeX = 0
//    let gameScene:GameScene
    
//    var hamster:SKSpriteNode
    
    override func didMoveToView(view: SKView) {
        
        let myLabel = SKLabelNode(fontNamed:"Arial")
        
        let upperRectangle = SKShapeNode(rect: CGRect(x:CGRectGetMinY(self.frame), y: CGRectGetMaxY(self.frame), width: self.frame.width, height: -150))
        upperRectangle.fillColor = UIColor.darkGrayColor()
        
        let lowerRectangle = SKShapeNode(rect: CGRect(x:CGRectGetMinY(self.frame), y: CGRectGetMaxY(self.frame).advancedBy(-200), width: self.frame.width, height: -(self.frame.height - 150)))
        lowerRectangle.fillColor = UIColor.purpleColor()
        
//                let upperRectangle =
        
//        upperRectangle.
        myLabel.text = "Hamster on a Piano";
        myLabel.fontSize = 35;
        myLabel.fontName = "Arial"
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame).advancedBy(-120));
//
        self.addChild(myLabel)
        
        hamster = SKSpriteNode(imageNamed:"hamster-1")
        
        //            sprite.physicsBody.affectedByGravity
        
        hamster.xScale = 1
        hamster.yScale = 1
        var hamsterPosition = CGRectGetMinY(self.frame).advancedBy(70)
        hamster.position = CGPoint(x:CGRectGetMidX(self.frame), y:hamsterPosition);
//        hamster.physicsBody = SKPhysicsBody()
//        hamster.physicsBody.density = 4.0
        
                self.addChild(upperRectangle)
        self.addChild(hamster)

                        self.addChild(lowerRectangle)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        
        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
            var popcorn = PopcornFactory.createPopcorn(self.frame)
            
            var popcornSprite = popcorn.getSprite()
            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
            
//            sprite.physicsBody.
//            popcornSprite.o
//            poppies += popcorn
//            popcornSprite.name = "P"
            
//            self.ch
            
            
            self.addChild(popcornSprite)
            
//            for o:SKSpriteNode in self.children {
//                if(o.type == "SKSpriteNode") {
//                  println(o.name)
//                }
//                if (o.name == "P") {


                
//            }
            test.append(popcornSprite)
            
            

        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        var normalizedTime = Int(currentTime.bridgeToObjectiveC())
        if ( (normalizedTime % 2 == 0) && currentTimeX != normalizedTime){
            currentTimeX = Int(currentTime)
        println(Int(currentTime.bridgeToObjectiveC()))
            
        var popcorn = PopcornFactory.createPopcorn(self.frame)
        
        var popcornSprite = popcorn.getSprite()
        
        //            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        //
        //            sprite.runAction(SKAction.repeatActionForever(action))
        
        //            sprite.physicsBody.
        //            popcornSprite.o
        //            poppies += popcorn
        //            popcornSprite.name = "P"
        
        //            self.ch
        
        
        self.addChild(popcornSprite)
        
        //            for o:SKSpriteNode in self.children {
        //                if(o.type == "SKSpriteNode") {
        //                  println(o.name)
        //                }
        //                if (o.name == "P") {
        
        
        
        //            }
        test.append(popcornSprite)
        
        
        for pop:SKSpriteNode in test {
            
            if(CGRectIntersectsRect(CGRect(x: pop.position.x, y: pop.position.y, width: 30, height: 30), CGRect(x: hamster.position.x, y: hamster.position.y, width: 60, height: 60))){
             println("Boom")
            }
            
            
//            if(pop.position.y <= 0) {
//                test.removeAtIndex(0)
//            }
//                    println(pop.position.y)
//            
        }
                    }
        

        
//        for p:Popcorn in self.children {
//            println(p)
//        }
      
        /* Called before each frame is rendered */
    }
}
