//
//  Position.swift
//  SudokuLibrary
//
//  Created by Watanabe Yuki on 2016/02/25.
//  Copyright © 2016 ACCESS. All rights reserved.
//

import Foundation

struct Position {

    let i, j: Int

    var isValid: Bool {
        return 0 <= i && i < size && 0 <= j && j < size
    }

    func right(delta: Int = 1) -> Position {
        return Position(i: i, j: j + delta)
    }

    func down(delta: Int = 1) -> Position {
        return Position(i: i + delta, j: j)
    }

}

extension Position: Equatable {
}

func ==(lhs: Position, rhs: Position) -> Bool {
    return lhs.i == rhs.i && lhs.j == rhs.j
}
