//
//  Solver.swift
//  SudokuLibrary
//
//  Created by Watanabe Yuki on 2016/02/25.
//  Copyright © 2016 ACCESS. All rights reserved.
//

import Foundation

enum BoardState {
    case Solved
    case Unsolved
    case Insolvable
}

func classify(board: Board<PossibilitySet>) -> BoardState {
    var state = BoardState.Solved

    wholeArea.forEach { (position: Position) -> Bool in
        let set = board[position]
        if set.isEmpty {
            state = BoardState.Insolvable
            return false
        }
        if !set.isUnique {
            state = BoardState.Unsolved
        }
        return true
    }

    return state
}

func findPositionWithLeastPossibilities(board: Board<PossibilitySet>) -> Position {
    var positionWithLeastPossibilities = Position(i: 0, j: 0)
    var leastCount = size + 1

    wholeArea.forEach { (position: Position) -> Bool in
        let count = board[position].count
        if 1 < count && count < leastCount {
            leastCount = count
            positionWithLeastPossibilities = position
        }
        return true
    }

    return positionWithLeastPossibilities
}

func eliminateImpossibilities(inout board: Board<PossibilitySet>) {
    wholeArea.forEach { (position1: Position) -> Bool in
        guard board[position1].isUnique else {
            return true
        }

        let number = board[position1].sum
        let eliminate = { (position2: Position) -> Bool in
            if position1 != position2 {
                board[position2].remove(number)
            }
            return true
        }

        Area.row(position1.i).forEach(eliminate)
        Area.column(position1.j).forEach(eliminate)
        Area.blockContaining(position1).forEach(eliminate)
        return true
    }
}

func fixUniquePossibilities(inout board: Board<PossibilitySet>, area: Area) {
    struct Possibility {
        var positionFound: Position?
        var count = 0
    }

    var possibilities = [Possibility](count: size, repeatedValue: Possibility())

    area.forEach { (position: Position) -> Bool in
        board[position].forEach { (number: Int) -> Bool in
            possibilities[number].positionFound = position
            possibilities[number].count += 1
            return true
        }
        return true
    }

    for (number, possibility) in possibilities.enumerate() {
        if possibility.count == 1 {
            board[possibility.positionFound!] = PossibilitySet(uniqueNumber: number)
        }
    }
}

func fixUniquePossibilities(inout board: Board<PossibilitySet>) {
    for n in 0 ..< size {
        fixUniquePossibilities(&board, area: Area.row(n))
        fixUniquePossibilities(&board, area: Area.column(n))
    }
    for block in allBlocks {
        fixUniquePossibilities(&board, area: block)
    }
}

func repeatNonAssumptionProcess(inout board: Board<PossibilitySet>) {
    var oldBoard: Board<PossibilitySet>
    repeat {
        oldBoard = board
        eliminateImpossibilities(&board)
        fixUniquePossibilities(&board)
    } while oldBoard != board
}

func iterateSolutionsWithAssumption(
    board: Board<PossibilitySet>, @noescape callback: Board<Int> throws -> ()) rethrows {

    let position = findPositionWithLeastPossibilities(board)

    try board[position].forEach { (number: Int) -> Bool in
        var nextBoard = board
        nextBoard[position] = PossibilitySet(uniqueNumber: number)
        try iterateSolutions(nextBoard, callback: callback)
        return true
    }
}

func iterateSolutions(
    var board: Board<PossibilitySet>, @noescape callback: Board<Int> throws -> ()) rethrows {

    repeatNonAssumptionProcess(&board)

    switch classify(board) {
    case .Solved:
        try callback(numbersFrom(board))
    case .Insolvable:
        break
    case .Unsolved:
        try iterateSolutionsWithAssumption(board, callback: callback)
    }
}

public func iterateSolutions(
    board: Board<Int>, @noescape callback: Board<Int> throws -> ()) rethrows {

    try iterateSolutions(possibilitiesFrom(board), callback: callback)
}
