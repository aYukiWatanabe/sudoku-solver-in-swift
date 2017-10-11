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

    for position in wholeArea {
        let set = board[position]
        if set.isEmpty {
            return BoardState.insolvable
        }
        if !set.isUnique {
            state = BoardState.unsolved
        }
    }

    return state
}

func findPositionWithLeastPossibilities(_ board: Board<PossibilitySet>) -> Position {
    var positionWithLeastPossibilities = Position(i: 0, j: 0)
    var leastCount = size + 1

    for position in wholeArea {
        let count = board[position].count
        if 1 < count && count < leastCount {
            leastCount = count
            positionWithLeastPossibilities = position
        }
    }

    return positionWithLeastPossibilities
}

func eliminateImpossibilities(_ board: inout Board<PossibilitySet>) {
    for position1 in wholeArea where board[position1].isUnique {
        let number = board[position1].sum
        for area in [Area.row(position1.i),
                     Area.column(position1.j),
                     Area.blockContaining(position1)] {
            for position2 in area where position1 != position2 {
                board[position2].remove(number)
            }
        }
    }
}

func fixUniquePossibilities(_ board: inout Board<PossibilitySet>, area: Area) {
    struct Possibility {
        var positionFound: Position?
        var count = 0
    }

    var possibilities = [Possibility](repeating: Possibility(), count: size)

    for position in area {
        for number in board[position] {
            possibilities[number].positionFound = position
            possibilities[number].count += 1
        }
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

    for number in board[position] {
        var nextBoard = board
        nextBoard[position] = PossibilitySet(uniqueNumber: number)
        try iterateSolutions(nextBoard, callback: callback)
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
