//
//  Swap.swift
//  Match Game
//
//  Created by Gabriel Nica on 15/06/2014.
//  Copyright (c) 2014 Gabriel Nica. All rights reserved.
//

import Foundation
import SpriteKit

struct TileSwap: Equatable
{
	var tileA: Tile?, tileB: Tile?
	
	func description() -> NSString
	{
		return "swap \(tileA!.description()) with \(tileB!.description())"
	}
	
	init(_ A: Tile, _ B: Tile)
	{
		tileA = A
		tileB = B
	}
}

@infix func ==(left: TileSwap, right: TileSwap) -> Bool {
	assert(left.tileA != nil && right.tileB != nil, "both swaps must exist!")
	return (left.tileA! == right.tileA! && left.tileB! == right.tileB!) ||
			(left.tileA! == right.tileB! && left.tileB! == right.tileA!)
}
