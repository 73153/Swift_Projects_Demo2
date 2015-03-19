//
//  GameScene.swift
//  Match Game
//
//  Created by Gabriel Nica on 14/06/2014.
//  Copyright (c) 2014 Gabriel Nica. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
	
	var backgroundImage = "Background"
	
	var gameLayer: SKNode
	var boardLayer: SKNode
	var gridLayer: SKNode
	var cropLayer: SKCropNode
	var maskLayer: SKNode
	
	var level: Level?
	
	var selectionSprite: SKSpriteNode
	
	// Sounds
	let swapSound = SKAction.playSoundFileNamed("Chomp.wav", waitForCompletion: false)
	let invalidSwapSound  = SKAction.playSoundFileNamed("Error.wav", waitForCompletion: false)
	let matchSound  = SKAction.playSoundFileNamed("Ka-Ching.wav", waitForCompletion: false)
	let fallingTileSound  = SKAction.playSoundFileNamed("Scrape.wav", waitForCompletion: false)
	let addTileSound  = SKAction.playSoundFileNamed("Drip.wav", waitForCompletion: false)
	
	var swipeFromColumn = NSNotFound, swipeFromRow = NSNotFound
	var swipeHandler: (swap: TileSwap)->()
	
	init(coder aDecoder: NSCoder!)  {
		gameLayer = SKNode()
		boardLayer = SKNode()
		cropLayer = SKCropNode()
		gridLayer = SKNode()
		maskLayer = SKNode()
		
		swipeHandler = {
			(swap: TileSwap) in
			
		}
		
		selectionSprite = SKSpriteNode()
		
		SKLabelNode(fontNamed: "GillSans-BoldItalic")
	
		super.init(coder: aDecoder)
	}
	
	override func didMoveToView(view: SKView) {
		
		let location: CGPoint = CGPoint(x: CGFloat(-TileWidth.asFloat() * MaxColumns.asFloat()/2.0), y:  CGFloat(-TileHeight.asFloat() * Float(MaxRows) / 2.0))
		
		
		anchorPoint = CGPointMake(0.5, 0.5)
		let background = SKSpriteNode(imageNamed: backgroundImage)
		addChild(background)
		
		gameLayer.hidden = false
		addChild(gameLayer)
		
		gridLayer.position = location
		maskLayer.position = location
		boardLayer.position = location
		gameLayer.addChild(gridLayer)
		gameLayer.addChild(cropLayer)
		cropLayer.maskNode = maskLayer
		
		gameLayer.addChild(boardLayer) //cropLayer.addChild(boardLayer)
		
		
		
	}
	
	func addSprites(tiles: Array<Tile>)
	{
		for tile in tiles
		{
			
			let sprite = SKSpriteNode(imageNamed: tile.spriteName())
			sprite.position = pointForCoords(tile.row, tile.column)
			boardLayer.addChild(sprite)
			tile.sprite = sprite
			
			tile.sprite!.alpha = 0
			tile.sprite!.xScale = 0.5
			tile.sprite!.yScale = 0.5
			
			tile.sprite!.runAction(SKAction.sequence([SKAction.waitForDuration(0.25, withRange: 0.5), SKAction.group([SKAction.fadeInWithDuration(0.25), SKAction.scaleTo(1.0, duration: 0.25)])]))
			
		}
		
	}
	
	func addGridTiles() {
		for row in 0..MaxRows
		{
			for column in 0..MaxColumns
			{
				if let gridTile = level!.grid[column, row] {
					let spriteNode = SKSpriteNode(imageNamed: "MaskTile")
					spriteNode.position = pointForCoords(row, column)
					maskLayer.addChild(spriteNode)
				}
			}
		}
		
		
		
		for row in 0...MaxRows
		{
			for column in 0...MaxColumns
			{
			
				let topLeft:	UInt8 = (column > 0			 && row < MaxRows && level!.grid[column - 1, row]     != nil) ? 1 : 0
				let bottomLeft: UInt8 = (column > 0			 && row > 0		  && level!.grid[column - 1, row - 1] != nil) ? 1 : 0
				let topRight:	UInt8 = (column < MaxColumns && row < MaxRows && level!.grid[column    , row]	  != nil) ? 1 : 0
				let bottomRight:UInt8 = (column < MaxColumns && row > 0		  && level!.grid[column    , row - 1] != nil) ? 1 : 0
				
				let value = topLeft | topRight << 1 | bottomLeft << 2 | bottomRight << 3
				
				if value != 0 && value != 6 && value != 9 {
					let name = "Tile_\(value)"
					var tileNode = SKSpriteNode(imageNamed: name)
					var point = pointForCoords(row, column)
					point.x -= CGFloat(TileWidth/2)
					point.y -= CGFloat(TileHeight/2)
					tileNode.position = point
					
					gridLayer.addChild(tileNode)
				}
			}
		}
	}
	
	func pointForCoords(row: Int, _ column: Int) -> CGPoint
	{
		return CGPoint(x: CGFloat(column.asFloat()*TileWidth.asFloat() + TileWidth.asFloat()/Float(2.0)), y: CGFloat(row.asFloat()*TileHeight.asFloat() + TileHeight.asFloat()/Float(2.0)))
	}
	
	func showSelectionIndicator(tile: Tile)
	{
		if selectionSprite.parent != .None
		{
			selectionSprite.removeFromParent()
		} 
		
		let texture = SKTexture(imageNamed: tile.highlightedSpriteName())
		selectionSprite.size = texture.size()
		selectionSprite.runAction(SKAction.setTexture(texture))
		
		tile.sprite!.addChild(selectionSprite)
		selectionSprite.alpha = 1.0
	}
	
	func hideSelectionIndicator() {
		selectionSprite.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.3),SKAction.removeFromParent()]))
	}
	
	func trySwap(#horizontalDelta: Int, verticalDelta: Int)
	{
		// We get here after the user performs a swipe. This sets in motion a whole
		// chain of events: 1) swap the cookies, 2) remove the matching lines, 3)
		// drop new cookies into the screen, 4) check if they create new matches,
		// and so on.
		
		let toColumn = swipeFromColumn + horizontalDelta
		let toRow = swipeFromRow + verticalDelta
		
		// Going outside the bounds of the array? This happens when the user swipes
		// over the edge of the grid. We should ignore such swipes.
		if toColumn < 0 || toColumn >= MaxColumns {
			return
		}
		if toRow < 0 || toRow >= MaxRows {
			return
		}
		
		let toTile = level!.tiles[toColumn, toRow]
		if toTile == nil {
			return
		}
		
		let fromTile  = level!.tiles[swipeFromColumn, swipeFromRow]
		
		if swipeHandler != nil
		{
			var swap = TileSwap(fromTile!, toTile!)
			swipeHandler(swap: swap)
		}
		
	}
	
	func animateSwap(swap: TileSwap, completion: dispatch_block_t)
	{
		swap.tileA!.sprite!.zPosition = 100
		swap.tileB!.sprite!.zPosition = 90
		
		let Duration = 0.3
		
		var moveA = SKAction.moveTo(swap.tileB!.sprite!.position, duration: Duration)
		moveA.timingMode = .EaseOut
		swap.tileA!.sprite!.runAction(SKAction.sequence([moveA, SKAction.runBlock(completion)]))
		
		var moveB = SKAction.moveTo(swap.tileA!.sprite!.position, duration: Duration)
		moveB.timingMode = .EaseOut
		swap.tileB!.sprite!.runAction(moveB)
		
		runAction(swapSound)
	}
	
	func animateInvalidSwap(swap: TileSwap, completion: dispatch_block_t)
	{
		swap.tileA!.sprite!.zPosition = 100
		swap.tileB!.sprite!.zPosition = 90
		
		let Duration = 0.2
		
		var moveA = SKAction.moveTo(swap.tileB!.sprite!.position, duration: Duration)
		moveA.timingMode = .EaseOut
		
		var moveB = SKAction.moveTo(swap.tileA!.sprite!.position, duration: Duration)
		moveB.timingMode = .EaseOut
		
		swap.tileA!.sprite!.runAction(SKAction.sequence([moveA, moveB, SKAction.runBlock(completion)]))
		swap.tileB!.sprite!.runAction(SKAction.sequence([moveB, moveA]))
		
		runAction(invalidSwapSound)
	}
	
	func animateMatchedTiles(chains: TileChain[], completion: dispatch_block_t)
	{
		for chain in chains
		{
			animateScoreForChain(chain)
			
			for tile in chain.tiles
			{
				if tile.sprite != nil
				{
					var scaleAction = SKAction.scaleTo(0.1, duration: 0.3)
					scaleAction.timingMode = .EaseOut
					
					tile.sprite!.runAction(SKAction.sequence([scaleAction, SKAction.removeFromParent()]))
					
					tile.sprite = nil
				}
			}
		}
		
		runAction(matchSound)
		runAction(SKAction.sequence([SKAction.waitForDuration(0.3), SKAction.runBlock(completion)]))
	}
	
	func animateFallingTiles(columns: Array<Tile[]>, completion: dispatch_block_t)
	{
		var longestDuration: Double = 0
		
		for array in columns
		{
			for (index, value) in enumerate(array)
			{
				let newPosition = pointForCoords(value.row, value.column)
				let delay = 0.05 + 0.15 * Double(index)
				let duration = ((Double(value.sprite!.position.y) - Double(newPosition.y)) / TileHeight) * 0.1
				longestDuration = max(longestDuration, duration+delay)
				
				var moveAction = SKAction.moveTo(newPosition, duration: duration)
				moveAction.timingMode = .EaseOut
				
				value.sprite!.runAction(SKAction.sequence([SKAction.waitForDuration(delay), SKAction.group([moveAction, fallingTileSound])]))
			}
		}
		
		runAction(SKAction.sequence([SKAction.waitForDuration(longestDuration), SKAction.runBlock(completion)]))
	}
	
	func animateNewTiles(columns: Array<Tile[]>, completion: dispatch_block_t)
	{
		var longestDuration: Double = 0
		
		for array in columns
		{
			let startRow = array[0].row + 1
			
			for (index, value) in enumerate(array)
			{
				var sprite = SKSpriteNode(imageNamed: value.spriteName())
				sprite.position = pointForCoords(startRow, value.column)
				boardLayer.addChild(sprite)
				value.sprite = sprite
				
				let delay = 0.1 + 0.2 * Double(array.count - index - 1)
				let duration = Double(startRow - value.row) * 0.1
				longestDuration = max(longestDuration, duration+delay)
				
				let newPosition = pointForCoords(value.row, value.column)
				var moveAction = SKAction.moveTo(newPosition, duration: duration)
				moveAction.timingMode = .EaseOut
				value.sprite!.alpha = 0
				
				value.sprite!.runAction(SKAction.sequence([SKAction.waitForDuration(delay), SKAction.group([SKAction.fadeInWithDuration(0.05), moveAction, addTileSound])]))
			}
		}
		
		runAction(SKAction.sequence([SKAction.waitForDuration(longestDuration), SKAction.runBlock(completion)]))
	}
	
	func animateScoreForChain(chain: TileChain)
	{
		let firstTile = chain.tiles[0]
		let lastTile = chain.tiles[chain.tiles.count-1]
		
		if (lastTile.sprite == nil || firstTile.sprite == nil)
		{
			return
		}
		
		let centerPosition = CGPoint(x: (firstTile.sprite!.position.x + lastTile.sprite!.position.x)/2, y: (firstTile.sprite!.position.y + lastTile.sprite!.position.y)/2 - 8)
		
		var scoreLabel = SKLabelNode(fontNamed: "GillSans-BoldItalic")
		scoreLabel.fontSize = 16
		scoreLabel.text = "\(chain.score)"
		scoreLabel.position = centerPosition
		scoreLabel.zPosition = 300
		
		boardLayer.addChild(scoreLabel)
		
		var moveAction = SKAction.moveBy(CGVector(0,3), duration: 0.7)
		moveAction.timingMode = .EaseOut
		
		scoreLabel.runAction(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
	}
	
	func animateGameOver() {
		var action = SKAction.moveBy(CGVector(0, -size.height), duration: 0.3)
		action.timingMode = .EaseIn
		
		gameLayer.runAction(action)
	}
	
	func animateBeginGame() {
		gameLayer.hidden = false
		
		gameLayer.position = CGPoint(x: 0, y: size.height)
		var action = SKAction.moveBy(CGVector(0, -size.height), duration: 0.3)
		action.timingMode = .EaseOut
		
		gameLayer.runAction(action)
	}
	
	func removeAllTileSprites()
	{
		boardLayer.removeAllChildren()
	}
	
	// Touch Handling

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
	{
		
		
		let touch: UITouch = touches.anyObject() as UITouch
        let location = touch.locationInNode(boardLayer)
            
		var column: Int = NSNotFound, row: Int = NSNotFound
		if location.convertTo(&column, row: &row)
		{
			if let tile = level!.tiles[column, row]
			{
				swipeFromColumn = column
				swipeFromRow = row
				
				showSelectionIndicator(tile)
			}
		}
		
    }
	
	override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)
	{
		if swipeFromColumn == NSNotFound {
			return
		}
		
		let touch = touches.anyObject() as UITouch
		let location = touch.locationInNode(boardLayer)
		
		var column: Int = NSNotFound, row: Int = NSNotFound
		if location.convertTo(&column, row: &row)
		{
			var horizDelta: Int = 0
			var vertDelta: Int = 0
			
			if (column < swipeFromColumn) {
				horizDelta = -1
			} else if (column > swipeFromColumn) {
				horizDelta = 1
			} else if (row < swipeFromRow) {
				vertDelta = -1
			} else if (row > swipeFromRow) {
				vertDelta = 1
			}
			
			if (horizDelta != 0 || vertDelta != 0)
			{
				trySwap(horizontalDelta: horizDelta, verticalDelta: vertDelta)
				hideSelectionIndicator()
				swipeFromColumn = NSNotFound
			}
		}
		
	}
	
	override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)
	{
		if selectionSprite.parent != .None && swipeFromColumn != NSNotFound
		{
			hideSelectionIndicator()
		}
		
		swipeFromColumn = NSNotFound; swipeFromRow = NSNotFound
	}
	
	override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!)
	{
		touchesEnded(touches, withEvent: event)
	}
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}


