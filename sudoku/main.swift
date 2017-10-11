//
//  main.swift
//  sudoku
//
//  Created by Watanabe Yuki on 2016/02/23.
//  Copyright © 2016 ACCESS. All rights reserved.
//

import Foundation
import SudokuLibrary

func number(_ string: Substring) -> Int {
    guard let value = Int(string) else {
        return size
    }
    guard 1 <= value && value <= size else {
        return size
    }
    return value - 1
}

func readLineInts() -> [Int] {
    let line = readLine() ?? ""
    return line.split { $0 == " " || $0 == "\t" }.map(number)
}

func readLinesBoard() -> Board<Int> {
    var board = Board<Int>(element: size)
    for row in 0 ..< size {
        let ints = readLineInts()
        for (column, number) in ints.enumerated() {
            board[Position(i: row, j: column)] = number
        }
    }
    return board
}

func print(_ board: Board<Int>) {
    for i in 0 ..< size {
        for j in 0 ..< size {
            let number = board[Position(i: i, j: j)]
            if 0 <= number && number < size {
                print(number + 1, terminator: " ")
            } else {
                print(0, terminator: " ")
            }
        }
        print("")
    }
}

let problem = readLinesBoard()
iterateSolutions(board: problem, callback: print)
