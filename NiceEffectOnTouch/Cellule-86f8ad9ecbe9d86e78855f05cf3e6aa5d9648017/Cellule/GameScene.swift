//
//  GameScene.swift
//  Cellule
//
//  Created by Justin Morris on 6/11/14.
//  Copyright (c) 2014 Justin Morris. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var cells: SKSpriteNode[] = []

    override func didMoveToView( view: SKView ) {

        // setup physics
        self.physicsWorld.gravity         = CGVectorMake( 0, 0 )
        self.physicsWorld.contactDelegate = self

        self.physicsBody = SKPhysicsBody( edgeLoopFromRect: self.frame )

//        self.physicsBody.categoryBitMask    = 1 << 0
//        self.physicsBody.collisionBitMask   = 1 << 0
//        self.physicsBody.contactTestBitMask = 1 << 0

        // setup background color
        self.backgroundColor = SKColor( red: 50 / 255.0, green: 50 / 255.0, blue: 50 / 255.0, alpha: 1.0 )

        for index in 1...100 {
            var cell = Cell( location: getRandomPoint() )

            addChild( cell )
            cells.append( cell )
        }

    }
    
    override func touchesBegan( touches: NSSet, withEvent event: UIEvent ) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode( self )

            var cell = Cell( location: location )

            addChild( cell )
            cells.append( cell )
        }
    }
    
    override func update( currentTime: CFTimeInterval ) {
        for cell in cells {
            if cell.physicsBody.velocity.dx < 100 && cell.physicsBody.velocity.dy < 100 {
                cell.physicsBody.applyImpulse( getRandomVelocity( 500 ) )
            }
        }
    }

    func didBeginContact( contact: SKPhysicsContact ) {
        if contact.bodyA.categoryBitMask != contact.bodyB.categoryBitMask {
//            if contact.bodyA.node.traits.strength > contact.bodyB.node.traits.strength {
                contact.bodyA.node.removeFromParent()
//            }
        }
    }

    func getRandomPoint() -> CGPoint {
        var x: Int = Int( arc4random_uniform( UInt32( size.width - 10 ) ) ) + 10
        var y: Int = Int( arc4random_uniform( UInt32( size.height - 10 ) ) ) + 10
        
        return CGPoint( x: x, y: y )
    }

    func randRange( lower: Int, upper: Int ) -> Int {
        return lower + Int( arc4random_uniform( UInt32( upper - lower + 1 ) ) )
    }

    func getRandomVelocity( r: Int ) -> CGVector {
        let x = randRange( -r, upper: r )
        let y = randRange( -r, upper: r )

        return CGVector( x, y )
    }

}
