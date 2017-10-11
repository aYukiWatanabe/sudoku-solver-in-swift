//
//  Area.swift
//  SudokuLibrary
//
//  Created by Watanabe Yuki on 2016/02/25.
//  Copyright © 2016 ACCESS. All rights reserved.
//

struct Area {

    let topLeft, bottomRight: Position

    func contains(_ position: Position) -> Bool {
        return topLeft.i <= position.i && position.i < bottomRight.i &&
                topLeft.j <= position.j && position.j < bottomRight.j
    }

}

extension Area: Sequence {

    typealias Iterator = AnyIterator<Position>

    func makeIterator() -> AnyIterator<Position> {
        var position = topLeft
        return AnyIterator {
            guard self.contains(position) else {
                return nil
            }
            defer {
                position = position.right()
                if !self.contains(position) {
                    position = Position(i: position.down().i, j: self.topLeft.j)
                }
            }
            return position
        }
    }

}

let wholeArea = Area(topLeft: Position(i: 0, j: 0), bottomRight: Position(i: size, j: size))

extension Area { // auxiliary constructors

    static func row(_ i: Int) -> Area {
        return Area(topLeft: Position(i: i, j: 0), bottomRight: Position(i: i + 1, j: size))
    }

    static func column(_ j: Int) -> Area {
        return Area(topLeft: Position(i: 0, j: j), bottomRight: Position(i: size, j: j + 1))
    }

    static func blockContaining(_ position: Position) -> Area {
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
