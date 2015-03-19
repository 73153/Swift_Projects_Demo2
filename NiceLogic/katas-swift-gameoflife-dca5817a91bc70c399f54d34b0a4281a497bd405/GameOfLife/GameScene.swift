//
//  GameScene.swift
//  GameOfLife
//
//  Created by Marten Veldthuis on 07/06/14.
//  Copyright (c) 2014 Marten Veldthuis. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var board = Board(rows: 10, columns: 10)
    let green = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
    let black = UIColor(white: 0, alpha: 1)
    var cells = Array<SKSpriteNode>()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        for row in 0..board.rows {
            for column in 0..board.columns {
                let sprite = SKSpriteNode(color: black, size: CGSize(width: 20, height: 20))
                sprite.position = CGPoint(x: 50*row+290, y: 50*column+100)
                cells.append(sprite)
                self.addChild(sprite)
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        board = Board(rows: board.rows, columns: board.columns)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        for i in 0..board.grid.count {
            let color  = board.grid[i] == 1 ? green : black
            let sprite = cells[i]
            sprite.color = color
        }

        board.nextState()
    }
}
