//
//  Board.swift
//  GameOfLife
//
//  Created by Marten Veldthuis on 07/06/14.
//  Copyright (c) 2014 Marten Veldthuis. All rights reserved.
//

import Foundation

struct Board {
    let rows: Int
    let columns: Int
    var grid: Array<Int>
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.grid = Array<Int>(count: (rows * columns), repeatedValue: 0)
        for i in 0..grid.count {
            self.grid[i] = randValue()
        }
    }
    
    func randValue() -> Int {
        if Int(arc4random_uniform(2)) == 0 { return 1 } else { return 0}
    }

    func indexFor(row: Int, column: Int) -> Int {
        let correctedRow = (row+rows) % rows
        let correctedColumn = (column+columns) % columns
        
        return (correctedRow * columns) + correctedColumn
    }
    
    subscript(row: Int, column: Int) -> Int {
        get {
            return grid[indexFor(row, column: column)]
        }
        set {
            grid[indexFor(row, column: column)] = newValue
        }
    }
    
    func countAlive(row: Int, column: Int) -> Int {
        return self[row-1, column-1] + self[row-1, column] + self[row-1, column+1] +
               self[row,   column-1] + 0                   + self[row,   column+1] +
               self[row+1, column-1] + self[row+1, column] + self[row+1, column+1]
    }
    
    mutating func nextState() {
        let next = Array(count: grid.count, repeatedValue: 0)
        for row in 0..rows {
            for column in 0..columns {
                let aliveNeighbours = countAlive(row, column: column)
                let alive = self[row, column] == 1
                
                if alive && (aliveNeighbours < 2 || aliveNeighbours > 3) {
                    next[indexFor(row, column: column)] = 0
                } else if !alive && aliveNeighbours == 3 {
                    next[indexFor(row, column: column)] = 1
                } else {
                    next[indexFor(row, column: column)] = self[row, column]
                }
            }
        }
        grid = next
    }
}