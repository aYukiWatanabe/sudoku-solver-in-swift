//
//  Area.swift
//  SudokuLibrary
//
//  Created by Watanabe Yuki on 2016/02/25.
//  Copyright © 2016 ACCESS. All rights reserved.
//

struct Area {

    let rows, columns: CountableRange<Int>

    func contains(_ position: Position) -> Bool {
        return rows.contains(position.i) && columns.contains(position.j)
    }

    var topLeft: Position {
        return Position(i: rows.lowerBound, j: columns.lowerBound)
    }
    var bottomRight: Position {
        return Position(i: rows.upperBound, j: columns.upperBound)
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
                    position = Position(i: position.i + 1, j: self.columns.lowerBound)
                }
            }
            return position
        }
    }

}

let wholeArea = Area(rows: 0..<size, columns: 0..<size)

extension Area { // auxiliary constructors

    static func row(_ i: Int) -> Area {
        return Area(rows: i ..< i + 1, columns: 0 ..< size)
    }

    static func column(_ j: Int) -> Area {
        return Area(rows: 0 ..< size, columns: j ..< j + 1)
    }

    static func block(containing position: Position) -> Area {
        let topLeft = Position(i: position.i / subsize * subsize,
                               j: position.j / subsize * subsize)
        return Area(rows: topLeft.i ..< topLeft.i + subsize,
                    columns: topLeft.j ..< topLeft.j + subsize)
    }

}

let allBlocks = { () -> [Area] in
    var blocks: [Area] = []
    for i in 0 ..< subsize {
        for j in 0 ..< subsize {
            blocks.append(Area.block(containing: Position(i: i * subsize, j: j * subsize)))
        }
    }
    return blocks
}()
