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
        var ns = Board<Int>(element: size)
        ns[Position(i: 0, j: 0)] = 0
        ns[Position(i: 1, j: 0)] = 1
        ns[Position(i: 0, j: 2)] = 2
        let ps = possibilities(from: ns)
        XCTAssertEqual(ps[Position(i: 0, j: 0)], PossibilitySet(numberBits: 0x1))
        XCTAssertEqual(ps[Position(i: 1, j: 0)], PossibilitySet(numberBits: 0x2))
        XCTAssertEqual(ps[Position(i: 0, j: 2)], PossibilitySet(numberBits: 0x4))
        XCTAssertEqual(ps[Position(i: 3, j: 3)], PossibilitySet.full())
        XCTAssertEqual(ps[Position(i: 3, j: 4)], PossibilitySet.full())
        XCTAssertEqual(ps[Position(i: 4, j: 4)], PossibilitySet.full())
    }

    func testNumbersFrom() {
        var ps = Board<PossibilitySet>(element: PossibilitySet())
        ps[Position(i: 0, j: 0)] = PossibilitySet(numberBits: 0x3)
        ps[Position(i: 1, j: 0)] = PossibilitySet(numberBits: 0x2)
        ps[Position(i: 0, j: 2)] = PossibilitySet(numberBits: 0x1)
        let ns = numbers(from: ps)
        XCTAssertEqual(ns[Position(i: 0, j: 0)], size)
        XCTAssertEqual(ns[Position(i: 1, j: 0)], 1)
        XCTAssertEqual(ns[Position(i: 0, j: 2)], 0)
        XCTAssertEqual(ns[Position(i: 3, j: 5)], size)
        XCTAssertEqual(ns[Position(i: 4, j: 5)], size)
        XCTAssertEqual(ns[Position(i: 4, j: 6)], size)
    }

}
