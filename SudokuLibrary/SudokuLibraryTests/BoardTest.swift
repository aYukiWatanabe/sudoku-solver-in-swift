//
//  BoardTest.swift
//  SudokuLibrary
//
//  Created by Watanabe Yuki on 2016/02/25.
//  Copyright © 2016 ACCESS. All rights reserved.
//

@testable import SudokuLibrary
import XCTest

class BoardTest: XCTestCase {

    func testPossibilitiesFrom() {
        var numbers = Board<Int>(element: size)
        numbers[Position(i: 0, j: 0)] = 0
        numbers[Position(i: 1, j: 0)] = 1
        numbers[Position(i: 0, j: 2)] = 2
        let possibilities = possibilitiesFrom(numbers)
        XCTAssertEqual(possibilities[Position(i: 0, j: 0)], PossibilitySet(0x1))
        XCTAssertEqual(possibilities[Position(i: 1, j: 0)], PossibilitySet(0x2))
        XCTAssertEqual(possibilities[Position(i: 0, j: 2)], PossibilitySet(0x4))
        XCTAssertEqual(possibilities[Position(i: 3, j: 3)], PossibilitySet.full())
        XCTAssertEqual(possibilities[Position(i: 3, j: 4)], PossibilitySet.full())
        XCTAssertEqual(possibilities[Position(i: 4, j: 4)], PossibilitySet.full())
    }

    func testNumbersFrom() {
        var possibilities = Board<PossibilitySet>(element: PossibilitySet())
        possibilities[Position(i: 0, j: 0)] = PossibilitySet(0x3)
        possibilities[Position(i: 1, j: 0)] = PossibilitySet(0x2)
        possibilities[Position(i: 0, j: 2)] = PossibilitySet(0x1)
        let numbers = numbersFrom(possibilities)
        XCTAssertEqual(numbers[Position(i: 0, j: 0)], size)
        XCTAssertEqual(numbers[Position(i: 1, j: 0)], 1)
        XCTAssertEqual(numbers[Position(i: 0, j: 2)], 0)
        XCTAssertEqual(numbers[Position(i: 3, j: 5)], size)
        XCTAssertEqual(numbers[Position(i: 4, j: 5)], size)
        XCTAssertEqual(numbers[Position(i: 4, j: 6)], size)
    }

}
