//
//  Board.swift
//  SudokuLibrary
//
//  Created by Watanabe Yuki on 2016/02/25.
//  Copyright © 2016 ACCESS. All rights reserved.
//

extension Position {

    fileprivate var index: Int {
        return i * size + j
    }

}

public struct Board<Element> where Element: Equatable {

    fileprivate var elements: [Element]

    public init(element: Element) {
        elements = [Element](repeating: element, count: size * size)
    }

    private init(elements: [Element]) {
        self.elements = elements
    }

    public subscript(position: Position) -> Element {
        get {
            return elements[position.index]
        }
        set(element) {
            elements[position.index] = element
        }
    }

    func map<NewElement>(_ transform: (Element) throws -> NewElement)
        rethrows -> Board<NewElement> {
        let newElements = try elements.map(transform)
        return Board<NewElement>(elements: newElements)
    }

}

func possibilitiesFrom(_ numbers: Board<Int>) -> Board<PossibilitySet> {
    return numbers.map { (number: Int) -> PossibilitySet in
        if number >= size {
            return PossibilitySet.full()
        }
        var set = PossibilitySet()
        set.add(number)
        return set
    }
}

func numbersFrom(_ possibilities: Board<PossibilitySet>) -> Board<Int> {
    return possibilities.map { (set: PossibilitySet) -> Int in
        set.isUnique ? set.sum : size
    }
}

extension Board: Equatable {
}

public func ==<Element>(lhs: Board<Element>, rhs: Board<Element>) -> Bool {
    return lhs.elements == rhs.elements
}
