//
//  Solver.swift
//  SudokuLibrary
//
//  Created by Watanabe Yuki on 2016/02/25.
//  Copyright © 2016 ACCESS. All rights reserved.
//

enum BoardState {
    case solved
    case unsolved
    case insolvable
}

func classify(_ board: Board<PossibilitySet>) -> BoardState {
    var state = BoardState.solved

    wholeArea.forEach { (position: Position) -> Bool in
        let set = board[position]
        if set.isEmpty {
            state = BoardState.insolvable
            return false
        }
        if !set.isUnique {
            state = BoardState.unsolved
        }
        return true
    }

    return state
}

func findPositionWithLeastPossibilities(_ board: Board<PossibilitySet>) -> Position {
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

func eliminateImpossibilities(_ board: inout Board<PossibilitySet>) {
    wholeArea.forEach { (position1: Position) -> Bool in
        guard board[position1].isUnique else {
            return true
        }

        let number = board[position1].sum

        Area.row(position1.i).forEach { position2 in
            if position1 != position2 {
                board[position2].remove(number)
            }
            return true
        }
        Area.column(position1.j).forEach { position2 in
            if position1 != position2 {
                board[position2].remove(number)
            }
            return true
        }
        Area.blockContaining(position1).forEach { position2 in
            if position1 != position2 {
                board[position2].remove(number)
            }
            return true
        }
        return true
    }
}

func fixUniquePossibilities(_ board: inout Board<PossibilitySet>, area: Area) {
    struct Possibility {
        var positionFound: Position?
        var count = 0
    }

    var possibilities = [Possibility](repeating: Possibility(), count: size)

    area.forEach { (position: Position) -> Bool in
        board[position].forEach { (number: Int) -> Bool in
            possibilities[number].positionFound = position
            possibilities[number].count += 1
            return true
        }
        return true
    }

    for (number, possibility) in possibilities.enumerated() where possibility.count == 1 {
        board[possibility.positionFound!] = PossibilitySet(uniqueNumber: number)
    }
}

func fixUniquePossibilities(_ board: inout Board<PossibilitySet>) {
    for n in 0 ..< size {
        fixUniquePossibilities(&board, area: Area.row(n))
        fixUniquePossibilities(&board, area: Area.column(n))
    }
    for block in allBlocks {
        fixUniquePossibilities(&board, area: block)
    }
}

func repeatNonAssumptionProcess(_ board: inout Board<PossibilitySet>) {
    var oldBoard: Board<PossibilitySet>
    repeat {
        oldBoard = board
        eliminateImpossibilities(&board)
        fixUniquePossibilities(&board)
    } while oldBoard != board
}

func iterateSolutionsWithAssumption(
    _ board: Board<PossibilitySet>, callback: (Board<Int>) throws -> Void) rethrows {

    let position = findPositionWithLeastPossibilities(board)

    try board[position].forEach { (number: Int) -> Bool in
        var nextBoard = board
        nextBoard[position] = PossibilitySet(uniqueNumber: number)
        try iterateSolutions(nextBoard, callback: callback)
        return true
    }
}

func iterateSolutions(
    _ board: Board<PossibilitySet>, callback: (Board<Int>) throws -> Void) rethrows {

    var board = board
    repeatNonAssumptionProcess(&board)

    switch classify(board) {
    case .solved:
        try callback(numbersFrom(board))
    case .insolvable:
        break
    case .unsolved:
        try iterateSolutionsWithAssumption(board, callback: callback)
    }
}

public func iterateSolutions(
    board: Board<Int>, callback: (Board<Int>) throws -> Void) rethrows {

    try iterateSolutions(possibilitiesFrom(board), callback: callback)
}
