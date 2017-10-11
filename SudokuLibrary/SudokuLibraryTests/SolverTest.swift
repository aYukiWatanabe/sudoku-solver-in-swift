//
//  SolverTest.swift
//  SudokuLibrary
//
//  Created by Watanabe Yuki on 2016/02/26.
//  Copyright © 2016 ACCESS. All rights reserved.
//

@testable import SudokuLibrary
import XCTest

func setUnique(_ board: inout Board<PossibilitySet>, position: Position, number: Int) {
    let eliminate = { (position2: Position) -> Bool in
        board[position2].remove(number)
        return true
    }

    Area.blockContaining(position).forEach(eliminate)
    Area.row(position.i).forEach(eliminate)
    Area.column(position.j).forEach(eliminate)
    board[position] = PossibilitySet(uniqueNumber: number)
}

class SolverTest: XCTestCase {

    func testEliminateImpossibilities() {
        var actualBoard = Board<PossibilitySet>(element: PossibilitySet())
        var expectedBoard = Board<PossibilitySet>(element: PossibilitySet())
        let position1 = Position(i: 0, j: 0)
        let position2 = Position(i: 8, j: 0)
        let position3 = Position(i: 3, j: 7)
        let number1 = 0, number2 = 3, number3 = 8

        wholeArea.forEach { (position: Position) -> Bool in
            actualBoard[position] = PossibilitySet.full()
            expectedBoard[position] = PossibilitySet.full()
            return true
        }
        actualBoard[position1] = PossibilitySet(uniqueNumber: number1)
        eliminateImpossibilities(&actualBoard)
        setUnique(&expectedBoard, position: position1, number: number1)
        XCTAssertEqual(actualBoard, expectedBoard)

        actualBoard[position2] = PossibilitySet(uniqueNumber: number2)
        actualBoard[position3] = PossibilitySet(uniqueNumber: number3)
        eliminateImpossibilities(&actualBoard)
        setUnique(&expectedBoard, position: position2, number: number2)
        setUnique(&expectedBoard, position: position3, number: number3)
        XCTAssertEqual(actualBoard, expectedBoard)
    }

    func testApplyUniquePossibilities() {
        var actualBoard = Board<PossibilitySet>(element: PossibilitySet.full())
        var expectedBoard = actualBoard

        fixUniquePossibilities(&actualBoard)
        XCTAssertEqual(actualBoard, expectedBoard)

        let position1 = Position(i: 0, j: 0)
        let position2 = Position(i: 3, j: 4)
        let position3 = Position(i: 3, j: 7)
        let position4 = Position(i: 2, j: 1)
        let position5 = Position(i: 6, j: 5)
        let number1 = 0, number2 = 2, number3 = 8, number4 = 5, number5 = number1

        Area.row(position1.i).forEach { (position: Position) -> Bool in
            actualBoard[position].remove(number1)
            return true
        }
        actualBoard[position1].add(number1)
        Area.row(position2.i).forEach { (position: Position) -> Bool in
            actualBoard[position].remove(number2)
            return true
        }
        actualBoard[position2].add(number2)
        Area.column(position3.j).forEach { (position: Position) -> Bool in
            actualBoard[position].remove(number3)
            return true
        }
        actualBoard[position3].add(number3)
        Area.blockContaining(position4).forEach { (position: Position) -> Bool in
            actualBoard[position].remove(number4)
            return true
        }
        actualBoard[position4].add(number4)
        Area.blockContaining(position5).forEach { (position: Position) -> Bool in
            actualBoard[position].remove(number5)
            return true
        }
        actualBoard[position5].add(number5)

        expectedBoard = actualBoard
        fixUniquePossibilities(&actualBoard)
        expectedBoard[position1] = PossibilitySet(uniqueNumber: number1)
        expectedBoard[position2] = PossibilitySet(uniqueNumber: number2)
        expectedBoard[position3] = PossibilitySet(uniqueNumber: number3)
        expectedBoard[position4] = PossibilitySet(uniqueNumber: number4)
        expectedBoard[position5] = PossibilitySet(uniqueNumber: number5)
        XCTAssertEqual(actualBoard, expectedBoard)
    }
}
