//
//  Area.swift
//  SudokuLibrary
//
//  Created by Watanabe Yuki on 2016/02/25.
//  Copyright © 2016 ACCESS. All rights reserved.
//

import Foundation

struct Area {

    let topLeft, bottomRight: Position

    func contains(position: Position) -> Bool {
        return topLeft.i <= position.i && position.i < bottomRight.i &&
                topLeft.j <= position.j && position.j < bottomRight.j
    }

    func forEach(@noescape body: Position throws -> Bool) rethrows -> Bool {
        for i in topLeft.i ..< bottomRight.i {
            for j in topLeft.j ..< bottomRight.j {
                if !(try body(Position(i: i, j: j))) {
                    return false
                }
            }
        }
        return true
    }

}

let wholeArea = Area(topLeft: Position(i: 0, j: 0), bottomRight: Position(i: size, j: size))

extension Area { // auxiliary constructors

    static func row(i: Int) -> Area {
        return Area(topLeft: Position(i: i, j: 0), bottomRight: Position(i: i + 1, j: size))
    }

    static func column(j: Int) -> Area {
        return Area(topLeft: Position(i: 0, j: j), bottomRight: Position(i: size, j: j + 1))
    }

    static func blockContaining(position: Position) -> Area {
        let topLeft = Position(i: position.i / subsize * subsize, j: position.j / subsize * subsize)
        let bottomRight = topLeft.down(subsize).right(subsize)
        return Area(topLeft: topLeft, bottomRight: bottomRight)
    }

}

let allBlocks = { () -> [Area] in
    var blocks: [Area] = []
    for i in 0 ..< subsize {
        for j in 0 ..< subsize {
            blocks.append(Area.blockContaining(Position(i: i * subsize, j: j * subsize)))
        }
    }
    return blocks
}()
