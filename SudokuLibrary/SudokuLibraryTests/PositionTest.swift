//
//  PositionTest.swift
//  SudokuLibrary
//
//  Created by Watanabe Yuki on 2016/02/25.
//  Copyright © 2016 ACCESS. All rights reserved.
//

@testable import SudokuLibrary
import XCTest

class PositionTest: XCTestCase {

    func testIsValid() {
        XCTAssertFalse(Position(i: -1, j: -1).isValid)
        XCTAssertFalse(Position(i: -1, j: 0).isValid)
        XCTAssertFalse(Position(i: 0, j: -1).isValid)
        XCTAssertTrue(Position(i: 0, j: 0).isValid)
        XCTAssertTrue(Position(i: 1, j: 1).isValid)
        XCTAssertTrue(Position(i: 0, j: size - 1).isValid)
        XCTAssertFalse(Position(i: 0, j: size).isValid)
        XCTAssertTrue(Position(i: size - 1, j: 0).isValid)
        XCTAssertFalse(Position(i: size, j: 0).isValid)
        XCTAssertTrue(Position(i: size - 1, j: size - 1).isValid)
        XCTAssertFalse(Position(i: size, j: size - 1).isValid)
        XCTAssertFalse(Position(i: size - 1, j: size).isValid)
        XCTAssertFalse(Position(i: size, j: size).isValid)
    }

    func testRight() {
        XCTAssertEqual(Position(i: 2, j: 4).right(), Position(i: 2, j: 5))
        XCTAssertEqual(Position(i: 2, j: 4).right(3), Position(i: 2, j: 7))
        XCTAssertEqual(Position(i: 2, j: 4).right(5), Position(i: 2, j: 9))

        XCTAssertEqual(Position(i: 5, j: 2).right(), Position(i: 5, j: 3))
        XCTAssertEqual(Position(i: 5, j: 2).right(3), Position(i: 5, j: 5))
        XCTAssertEqual(Position(i: 5, j: 2).right(5), Position(i: 5, j: 7))
    }

    func testDown() {
        XCTAssertEqual(Position(i: 2, j: 4).down(), Position(i: 3, j: 4))
        XCTAssertEqual(Position(i: 2, j: 4).down(3), Position(i: 5, j: 4))
        XCTAssertEqual(Position(i: 2, j: 4).down(7), Position(i: 9, j: 4))

        XCTAssertEqual(Position(i: 5, j: 2).down(), Position(i: 6, j: 2))
        XCTAssertEqual(Position(i: 5, j: 2).down(3), Position(i: 8, j: 2))
        XCTAssertEqual(Position(i: 5, j: 2).down(7), Position(i: 12, j: 2))
    }

}
