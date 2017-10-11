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

func findPositionWithLeastPossibilities(in board: Board<PossibilitySet>) -> Position {
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

func eliminateImpossibilities(from board: inout Board<PossibilitySet>) {
    for position1 in wholeArea where board[position1].isUnique {
        let number = board[position1].sum
        for area in [Area.row(position1.i),
                     Area.column(position1.j),
                     Area.block(containing: position1)] {
            for position2 in area where position1 != position2 {
                board[position2].remove(number)
            }
        }
    }
}

func fixUniquePossibilities(in board: inout Board<PossibilitySet>, per area: Area) {
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

func fixUniquePossibilities(in board: inout Board<PossibilitySet>) {
    for n in 0 ..< size {
        fixUniquePossibilities(in: &board, per: Area.row(n))
        fixUniquePossibilities(in: &board, per: Area.column(n))
    }
    for block in allBlocks {
        fixUniquePossibilities(in: &board, per: block)
    }
}

func repeatNonAssumptionProcess(on board: inout Board<PossibilitySet>) {
    var oldBoard: Board<PossibilitySet>
    repeat {
        oldBoard = board
        eliminateImpossibilities(from: &board)
        fixUniquePossibilities(in: &board)
    } while oldBoard != board
}

func iterateSolutionsWithAssumption(
    in board: Board<PossibilitySet>, callback: (Board<Int>) throws -> Void) rethrows {

    let position = findPositionWithLeastPossibilities(in: board)

    for number in board[position] {
        var nextBoard = board
        nextBoard[position] = PossibilitySet(uniqueNumber: number)
        try iterateSolutions(nextBoard, callback: callback)
    }
}

func iterateSolutions(
    _ board: Board<PossibilitySet>, callback: (Board<Int>) throws -> Void) rethrows {

    var board = board
    repeatNonAssumptionProcess(on: &board)

    switch classify(board) {
    case .solved:
        try callback(numbers(from: board))
    case .insolvable:
        break
    case .unsolved:
        try iterateSolutionsWithAssumption(in: board, callback: callback)
    }
}

public func iterateSolutions(
    board: Board<Int>, callback: (Board<Int>) throws -> Void) rethrows {

    try iterateSolutions(possibilities(from: board), callback: callback)
}
