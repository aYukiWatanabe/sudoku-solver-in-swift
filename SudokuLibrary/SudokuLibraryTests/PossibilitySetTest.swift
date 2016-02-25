//
//  PossibilitySetTest.swift
//  SudokuLibrary
//
//  Created by Watanabe Yuki on 2016/02/23.
//  Copyright © 2016 ACCESS. All rights reserved.
//

@testable import SudokuLibrary
import XCTest

class PossibilitySetTest: XCTestCase {

    func testPossibilitySetAdd() {
        var set = PossibilitySet()
        set.add(0)
        XCTAssertEqual(set, PossibilitySet(0x1))

        set.add(2)
        XCTAssertEqual(set, PossibilitySet(0x5))

        set.add(8)
        XCTAssertEqual(set, PossibilitySet(0x105))

        set.add(2) // adding an already-added number again
        XCTAssertEqual(set, PossibilitySet(0x105))
    }

    func testPossibilitySetRemove() {
        var set = PossibilitySet.full()
        set.remove(0)
        XCTAssertEqual(set, PossibilitySet(0x1FE))

        set.remove(2)
        XCTAssertEqual(set, PossibilitySet(0x1FA))

        set.remove(8)
        XCTAssertEqual(set, PossibilitySet(0xFA))

        set.remove(2) // removing an already-removed number again
        XCTAssertEqual(set, PossibilitySet(0xFA))
    }

    func testPossibilitySetFull() {
        let set = PossibilitySet.full()
        XCTAssertTrue(set.contains(0))
        XCTAssertTrue(set.contains(1))
        XCTAssertTrue(set.contains(2))
        XCTAssertTrue(set.contains(3))
        XCTAssertTrue(set.contains(4))
        XCTAssertTrue(set.contains(5))
        XCTAssertTrue(set.contains(6))
        XCTAssertTrue(set.contains(7))
        XCTAssertTrue(set.contains(8))
    }

    func testPossibilityTestContains() {
        let emptySet = PossibilitySet()
        XCTAssertFalse(emptySet.contains(0))
        XCTAssertFalse(emptySet.contains(1))
        XCTAssertFalse(emptySet.contains(2))
        XCTAssertFalse(emptySet.contains(3))
        XCTAssertFalse(emptySet.contains(4))
        XCTAssertFalse(emptySet.contains(5))
        XCTAssertFalse(emptySet.contains(6))
        XCTAssertFalse(emptySet.contains(7))
        XCTAssertFalse(emptySet.contains(8))

        let set = PossibilitySet(0x105)
        XCTAssertTrue(set.contains(0))
        XCTAssertFalse(set.contains(1))
        XCTAssertTrue(set.contains(2))
        XCTAssertFalse(set.contains(3))
        XCTAssertFalse(set.contains(4))
        XCTAssertFalse(set.contains(5))
        XCTAssertFalse(set.contains(6))
        XCTAssertFalse(set.contains(7))
        XCTAssertTrue(set.contains(8))
    }

    func testPossibilitySetCount() {
        var set = PossibilitySet()
        XCTAssertEqual(set.count, 0)
        set.add(4)
        XCTAssertEqual(set.count, 1)
        set.add(2)
        XCTAssertEqual(set.count, 2)
        set.add(7)
        XCTAssertEqual(set.count, 3)
        set.add(5)
        XCTAssertEqual(set.count, 4)
        set.add(1)
        XCTAssertEqual(set.count, 5)
        set.add(8)
        XCTAssertEqual(set.count, 6)
        set.add(3)
        XCTAssertEqual(set.count, 7)
        set.add(0)
        XCTAssertEqual(set.count, 8)
        set.add(6)
        XCTAssertEqual(set.count, 9)
    }

    func testPossibilitySetIsEmpty() {
        let emptySet = PossibilitySet()
        XCTAssertTrue(emptySet.isEmpty)

        let nonEmptySet = PossibilitySet(1)
        XCTAssertFalse(nonEmptySet.isEmpty)
    }

    func testPossibilitySetIsUnique() {
        var set = PossibilitySet()
        XCTAssertFalse(set.isUnique)

        set.add(4)
        XCTAssertTrue(set.isUnique)

        set.add(8)
        XCTAssertFalse(set.isUnique)
    }

    func testPossibilitySetSum() {
        XCTAssertEqual(PossibilitySet(0).sum, 0)
        XCTAssertEqual(PossibilitySet(1).sum, 0)
        XCTAssertEqual(PossibilitySet(0x4).sum, 2)
        XCTAssertEqual(PossibilitySet(0x5).sum, 0 + 2)
        XCTAssertEqual(PossibilitySet(0x1F0).sum, 4 + 5 + 6 + 7 + 8)
    }

}
