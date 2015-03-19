//
//  Tiles.swift
//  Match Game
//
//  Created by Gabriel Nica on 14/06/2014.
//  Copyright (c) 2014 Gabriel Nica. All rights reserved.
//

import Foundation
import SpriteKit

let NumTileTypes: Int = 6
let TileWidth = 32.0
let TileHeight = 36.0

let spriteNames:String[] = [
	"Croissant",
	"Cupcake",
	"Danish",
	"Donut",
	"Macaroon",
	"SugarCookie",
]

let highlightedSpriteNames: String[] = [
	"Croissant-Highlighted",
	"Cupcake-Highlighted",
	"Danish-Highlighted",
	"Donut-Highlighted",
	"Macaroon-Highlighted",
	"SugarCookie-Highlighted",
]


class Tile: Equatable
{
	var row: Int, column: Int
	var type: Int
	var sprite: SKSpriteNode?
	
	var tint: UIColor
	
	init () {
		row = 0;
		column = 0
		type = 0
		tint = UIColor.clearColor()
	}
	
	func spriteName() -> String {
		return spriteNames[type - 1]
	}
	
	func highlightedSpriteName() -> String {
		return highlightedSpriteNames[type - 1]
	}
	
	func empty() -> Bool
	{
		return type == 0
	}
	
	func description() -> String
	{
		return "[r: \(row),c:\(column)](t: \(type))"
	}
}

@infix func ==(left: Tile, right: Tile) -> Bool {
	return (left.column == right.column) && (left.row == right.row) && (left.type == right.type)
}

class GridElement 
{
	// Note: To support different types of grid tiles, you can add different types here
	
	enum GridElementType
	{
		case Normal//, Jelly
	}
	
	var value: GridElementType = .Normal
	
	convenience init()
	{
		self.init(.Normal)
	}
	
	init(_ value: GridElementType)
	{
		self.value = value
	}
}