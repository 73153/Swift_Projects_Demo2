//
//  Chains.swift
//  Match Game
//
//  Created by Gabriel Nica on 15/06/2014.
//  Copyright (c) 2014 Gabriel Nica. All rights reserved.
//

import Foundation

let BaseChainScore = 60

struct TileChain
{
	enum ChainType {
		case Horizontal, Vertical
	}
	
	var tiles: Array<Tile> = Tile[]() // at the moment there are no private vars in swift. tiles is not readonly like intended 
	var type: ChainType = .Horizontal
	var score: UInt = 0
	
	mutating func add(tile: Tile)
	{
		tiles.append(tile)
	}
	
	mutating func changeType(newType: ChainType)
	{
		type = newType
	}
	
	func description() -> String
	{
		return "type: \(type) tiles: \(tiles)"
	}

	
	
}