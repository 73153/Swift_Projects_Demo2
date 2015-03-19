//
//  Utilities.swift
//  Match Game
//
//  Created by Gabriel Nica on 14/06/2014.
//  Copyright (c) 2014 Gabriel Nica. All rights reserved.
//

import Foundation
import SpriteKit

extension Double
{
	func asFloat() -> Float
	{
		return Float(self)
	}
}

extension Int
{
	func asFloat() -> Float
	{
		return Float(self)
	}
}

struct Matrix<T> {
	let rows: Int, columns: Int
	var grid: T?[]
	init(rows: Int, columns: Int) {
		self.rows = rows
		self.columns = columns
		grid = Array<T?>(count: Int(rows * columns), repeatedValue: nil)
		
	}
	func indexIsValidForRow(row: Int, column: Int) -> Bool {
		return row >= 0 && row < rows && column >= 0 && column < columns
	}
	subscript(column: Int, row: Int) -> T? {
		get {
			assert(indexIsValidForRow(row, column: column), "Index out of range")
			return grid[(row * columns) + column]
		}
		set {
			assert(indexIsValidForRow(row, column: column), "Index out of range")
			grid[(row * columns) + column] = newValue
		}
	}
}

extension CGPoint
{
	func convertTo(inout column: Int, inout row: Int) -> Bool
	{
		if self.x >= 0.0 && Float(self.x) < MaxColumns.asFloat()*TileWidth.asFloat() &&
		   self.y >= 0.0 && Float(self.y) < MaxRows.asFloat()*TileHeight.asFloat()
		{
			column = Int(Float(self.x) / TileWidth.asFloat())
			row = Int(Float(self.y) / TileHeight.asFloat())
			return true
		} else {
			column = NSNotFound
			row = NSNotFound
			return false
		}
	}
}