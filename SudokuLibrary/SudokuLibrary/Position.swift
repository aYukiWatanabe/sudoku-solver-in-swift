//
//  Position.swift
//  SudokuLibrary
//
//  Created by Watanabe Yuki on 2016/02/25.
//  Copyright © 2016 ACCESS. All rights reserved.
//

public struct Position {

    let i, j: Int

    public init(i: Int, j: Int) {
        self.i = i
        self.j = j
    }

    var isValid: Bool {
        return 0 <= i && i < size && 0 <= j && j < size
    }

    func right(by delta: Int = 1) -> Position {
        return Position(i: i, j: j + delta)
    }

    func down(by delta: Int = 1) -> Position {
        return Position(i: i + delta, j: j)
    }

}

extension Position: Equatable {
}

public func ==(lhs: Position, rhs: Position) -> Bool {
    return lhs.i == rhs.i && lhs.j == rhs.j
}
