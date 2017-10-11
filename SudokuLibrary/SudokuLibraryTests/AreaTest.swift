//
//  AreaTest.swift
//  SudokuLibrary
//
//  Created by Watanabe Yuki on 2016/02/25.
//  Copyright © 2016 ACCESS. All rights reserved.
//

@testable import SudokuLibrary
import XCTest

class AreaTest: XCTestCase {

    func testContains() {
        let area = Area(topLeft: Position(i: 1, j: 3), bottomRight: Position(i: 6, j: 8))
        XCTAssertFalse(area.contains(Position(i: 0, j: 2)))
        XCTAssertFalse(area.contains(Position(i: 1, j: 2)))
        XCTAssertFalse(area.contains(Position(i: 0, j: 3)))
        XCTAssertTrue(area.contains(Position(i: 1, j: 3)))
        XCTAssertFalse(area.contains(Position(i: 5, j: 2)))
        XCTAssertFalse(area.contains(Position(i: 6, j: 2)))
        XCTAssertTrue(area.contains(Position(i: 5, j: 3)))
        XCTAssertFalse(area.contains(Position(i: 6, j: 3)))
        XCTAssertFalse(area.contains(Position(i: 0, j: 7)))
        XCTAssertTrue(area.contains(Position(i: 1, j: 7)))
        XCTAssertFalse(area.contains(Position(i: 0, j: 8)))
        XCTAssertFalse(area.contains(Position(i: 1, j: 8)))
        XCTAssertTrue(area.contains(Position(i: 5, j: 7)))
        XCTAssertFalse(area.contains(Position(i: 6, j: 7)))
        XCTAssertFalse(area.contains(Position(i: 5, j: 8)))
        XCTAssertFalse(area.contains(Position(i: 6, j: 8)))
    }

    func testBlockContainingPosition() {
        let area30 = Area.block(containing: Position(i: 3, j: 0))
        XCTAssertEqual(area30.topLeft, Position(i: 3, j: 0))
        XCTAssertEqual(area30.bottomRight, Position(i: 6, j: 3))

        let area52 = Area.block(containing: Position(i: 5, j: 2))
        XCTAssertEqual(area52.topLeft, Position(i: 3, j: 0))
        XCTAssertEqual(area52.bottomRight, Position(i: 6, j: 3))

        let area88 = Area.block(containing: Position(i: 8, j: 8))
        XCTAssertEqual(area88.topLeft, Position(i: 6, j: 6))
        XCTAssertEqual(area88.bottomRight, Position(i: 9, j: 9))
    }

}
