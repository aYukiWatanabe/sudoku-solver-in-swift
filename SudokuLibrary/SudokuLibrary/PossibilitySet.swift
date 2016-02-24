//
//  PossibilitySet.swift
//  SudokuLibrary
//
//  Created by Watanabe Yuki on 2016/02/23.
//  Copyright © 2016 ACCESS. All rights reserved.
//

import Foundation

public let subsize = 3
public let size = subsize * subsize

struct PossibilitySet {

    private var numberBits: Int = 0

    init() {
    }

    init(_ numberBits: Int) {
        self.numberBits = numberBits
    }

}

extension PossibilitySet { // mutators

    mutating func add(n: Int) {
        numberBits |= 1 << n
    }

    mutating func remove(n: Int) {
        numberBits &= ~(1 << n)
    }

}

extension PossibilitySet { // static constructors

    static func full() -> PossibilitySet {
        return PossibilitySet((1 << size) - 1)
    }

}

extension PossibilitySet { // computed properties and queries

    func contains(n: Int) -> Bool {
        return (numberBits & (1 << n)) != 0
    }

    var count: Int {
        let bits2 = (numberBits & 0x555) + ((numberBits >> 1) & 0x555)
        let bits4 = (bits2 & 0x333) + ((bits2 >> 2) & 0x333)
        let bits8 = (bits4 & 0xF0F) + ((bits4 >> 4) & 0xF0F)
        let bits16 = (bits8 & 0xFF) + ((bits8 >> 8) & 0xFF)
        return bits16
    }

    var isEmpty: Bool {
        return numberBits == 0
    }

    var isUnique: Bool {
        return count == 1
    }

    func forEach(@noescape body: Int throws -> Bool) rethrows -> Bool {
        for n: Int in 0..<size {
            if contains(n) {
                if (!(try! body(n))) {
                    return false
                }
            }
        }
        return true
    }

}

extension PossibilitySet: Equatable {
}

func ==(lhs: PossibilitySet, rhs: PossibilitySet) -> Bool {
    return lhs.numberBits == rhs.numberBits
}
