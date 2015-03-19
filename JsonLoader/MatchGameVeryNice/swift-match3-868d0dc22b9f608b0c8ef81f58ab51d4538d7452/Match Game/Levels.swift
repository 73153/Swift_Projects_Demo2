//
//  Levels.swift
//  Match Game
//
//  Created by Gabriel Nica on 14/06/2014.
//  Copyright (c) 2014 Gabriel Nica. All rights reserved.
//

import Foundation
import SpriteKit


let MaxRows = 9, MaxColumns = 9

class Level
{
	var tiles = Matrix<Tile>(rows: MaxRows, columns: MaxColumns)
	var grid = Matrix<GridElement>(rows: MaxRows, columns: MaxColumns)
	
	var targetScore = UInt(0)
	var maximumMoves = UInt(0)
	var comboMultiplier = UInt(1)
	
	var possibleSwaps: Array<TileSwap> = Array<TileSwap>()
	
	init (filename: String)
	{
		func loadJSON(filename: String) -> Dictionary<String, AnyObject>?
		{
			
			if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json")
			{
				var error: NSError? = nil
				println("Path: \(path)")
				if let data = NSData.dataWithContentsOfFile(path, options: NSDataReadingOptions(), error: &error)
				{
					if let dictionary : AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: &error)
					{
						return dictionary as? Dictionary<String, AnyObject>
					} else {
						println("Level file \(filename) is not valid JSON, error: \(error.description)")
					}
				} else {
					println("Could not load level file \(filename), error: \(error.description)")
				}
				
			} else {
				println("Could not find level file \(filename).json")
			}
			
			return nil
		}
		
		let dictionary = loadJSON(filename)
		let levelGrid : AnyObject? = dictionary!["tiles"]
		for (row, array : AnyObject) in enumerate(levelGrid! as AnyObject[])
		{
			let uwArray = array as Int[]
			for (column, value) in enumerate(uwArray)
			{
				let tileRow = MaxRows - row - 1
				if (value == 1) {
					grid[column, tileRow] = GridElement()
				}
			}
		}
		
		
		targetScore = UInt(dictionary!["targetScore"]!.unsignedIntegerValue!)
		maximumMoves = UInt(dictionary!["moves"]!.unsignedIntegerValue!)
	}
	
	func shuffle() -> Array<Tile>
	{
		func createInitialTiles() -> Array<Tile> {
			
			var set = Array<Tile>()
			
			for row in 0..MaxRows
			{
				for column in 0..MaxColumns
				{
					if let grid = grid[column, row]
					{
						var tileType: Int = 0
						do {
							tileType = Int(arc4random_uniform(UInt32(NumTileTypes)))+1
						} while (column >= 2 &&
								tiles[column - 1, row]?.type == tileType &&
								tiles[column - 2, row]?.type == tileType)
									||
								(row >= 2 &&
								tiles[column, row - 1]?.type == tileType &&
								tiles[column, row - 2]?.type == tileType)
		
						let tile:Tile = createTile(row, column, tileType)
						set.append(tile)
					}
				}
			}
			
			return set
		}
		
		var set: Tile[]
		
		do {
			set = createInitialTiles()
			detectPossibleSwaps()
			//dump(possibleSwaps)
		} while possibleSwaps.count == 0
		
		return set
	}
	
	func hasChainAt(#column: Int, row: Int) -> Bool
	{
		let tileType = tiles[column, row]!.type
		
		var horizLength = 1
		for var i = column - 1; i >= 0 && tiles[i, row] != nil && tiles[i, row]!.type == tileType; i--, horizLength++ {}
		for var i = column + 1; i < MaxColumns && tiles[i, row] != nil && tiles[i, row]!.type == tileType; i++, horizLength++ {}
		if (horizLength >= 3) {
			return true
		}
		
		var vertLength = 1
		for var i = row - 1; i >= 0 && tiles[column, i] != nil && tiles[column, i]!.type == tileType; i--, vertLength++ {}
		for var i = row + 1; i < MaxRows && tiles[column, i] != nil && tiles[column, i]!.type == tileType; i++, vertLength++ {}
		
		return vertLength >= 3
	}
	
	func detectPossibleSwaps() {
		var set = TileSwap[]()
		
		for row in 0..MaxRows
		{
			for column in 0..MaxColumns
			{
				if let tile = tiles[column, row]
				{
					if column < MaxColumns - 1 	{
						if let other = tiles[column + 1, row]
						{
							// swap
							(tiles[column, row], tiles[column + 1, row]) = (tiles[column + 1, row], tiles[column, row])
							
							if hasChainAt(column: column+1, row: row) || hasChainAt(column: column, row: row) {
								set.append(TileSwap(tile, other))
							}
							
							// swap them back
							(tiles[column, row], tiles[column + 1, row]) = (tiles[column + 1, row], tiles[column, row])
						}
					}
					
					if row < MaxRows - 1 	{
						if let other = tiles[column, row + 1]
						{
							// swap
							(tiles[column, row], tiles[column, row + 1]) = (tiles[column, row + 1], tiles[column, row])
							
							if hasChainAt(column: column, row: row+1) || hasChainAt(column: column, row: row) {
								set.append(TileSwap(tile, other))
							}
							
							// swap them back
							(tiles[column, row], tiles[column, row + 1]) = (tiles[column, row + 1], tiles[column, row])
						}
					}
				}
			}
		}
		
		possibleSwaps = set
	}
	
	func isPossibleSwap(swap: TileSwap) -> Bool {
		return contains(possibleSwaps, swap)
	}
	
	
	func createTile(row: Int, _ column: Int, _ type: Int) -> Tile
	{
		let tile = Tile()
		tile.column = column
		tile.row = row
		tile.type = type
		
		tiles[column, row] = tile
		
		return tile
	}
	
	func performSwap(swap: TileSwap)
	{
		println(swap.description())
		
		let columnA = swap.tileA!.column, rowA = swap.tileA!.row
		let columnB = swap.tileB!.column, rowB = swap.tileB!.row
		
		tiles[columnA, rowA] = swap.tileB
		swap.tileB!.column = columnA
		swap.tileB!.row = rowA
		
		tiles[columnB, rowB] = swap.tileA
		swap.tileA!.column = columnB
		swap.tileA!.row = rowB
		
		println(swap.description())
	}
	
	// Matches
	
	func detectHorizontalMatches() -> TileChain[] {
		var set: TileChain[] = TileChain[]()
		
		for row in 0..MaxRows
		{
			for var column = 0; column < MaxColumns-2 ;
			{
				if let tile = tiles[column, row]
				{
					let matchType = tile.type
					
					if tiles[column + 1, row]?.type == matchType && tiles[column + 2, row]?.type == matchType
					{
						var chain = TileChain()
						chain.type = .Horizontal
						do {
							chain.add(tiles[column, row]!)
							column += 1
						} while (column < MaxColumns && tiles[column, row]?.type == matchType)
						
						set.append(chain)
						
						continue
					}
				}
				
				column += 1
			}
			
		}
		
		return set
	}
	
	func detectVerticalMatches() -> TileChain[] {
		var set: TileChain[] = TileChain[]()
		
		for column in 0..MaxColumns
		{
			for var row = 0; row < MaxRows - 2 ;
			{
				if let tile = tiles[column, row]
				{
					let matchType = tile.type
					
					if tiles[column, row + 1]?.type == matchType && tiles[column, row + 2]?.type == matchType
					{
						var chain = TileChain()
						chain.type = .Vertical
						do {
							chain.add(tiles[column, row]!)
							row += 1
						} while (row < MaxRows && tiles[column, row]?.type == matchType)
						
						set.append(chain)
						
						continue
					}
				}
				
				row += 1
			}
			
		}
		
		return set
	}
	
	func removeMatches() -> TileChain[] {
		let horizontalChains = detectHorizontalMatches()
		let verticalChains = detectVerticalMatches()
		
		removeTilesFromChains(horizontalChains)
		removeTilesFromChains(verticalChains)
		
		calculateScores(horizontalChains)
		calculateScores(verticalChains)
		
		return horizontalChains + verticalChains
	}
	
	func removeTilesFromChains(chains: TileChain[])
	{
		for chain in chains
		{
			for tile in chain.tiles
			{
				tiles[tile.column, tile.row] = nil
			}
		}
	}

	
	func fillHoles() -> Array<Tile[]> {
		var columns = Array<Tile[]>()
		
		for column in 0..MaxColumns
		{
			var array = Tile[]()
			for row in 0..MaxRows
			{
				if grid[column, row] != nil  && tiles[column, row] == nil
				{
					for lookup in row+1..MaxRows
					{
						if let tile = tiles[column, lookup]
						{
							tiles[column, lookup] = nil
							tiles[column, row] = tile
							tile.row = row
							
							array.append(tile)
							
							break;
						}
						
					}
				}
			}
			if (array.count != 0) {
				columns.append(array)
			}
		}
		
		return columns
		
	}
	
	func topUpTiles() -> Array<Tile[]> {
		var columns = Array<Tile[]>()
		var tileType = 0
		
		for column in 0..MaxColumns
		{
			var array = Tile[]()
			for var row = MaxRows - 1; row >= 0 && tiles[column, row] == nil; row--
			{
				if grid[column, row] != nil
				{
					var newTileType = 0
					do {
						newTileType = Int(arc4random_uniform(UInt32(NumTileTypes)))+1
					} while (newTileType == tileType)
					tileType = newTileType
					
					let tile = createTile(row, column, tileType)
					array.append(tile)
					
				}
			}
			if (array.count != 0) {
				columns.append(array)
			}
		}
		
		return columns
	}
	
	func calculateScores(chains: TileChain[])
	{
		for var i=0; i < chains.count; i++
		{
			chains[i].score = UInt(BaseChainScore * (chains[i].tiles.count - 2)) * comboMultiplier
			comboMultiplier++
		}
	}
	
	func resetComboMultiplier() {
		comboMultiplier = 1
	}
	
}