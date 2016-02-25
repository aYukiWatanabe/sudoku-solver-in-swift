//
//  Board.swift
//  SudokuLibrary
//
//  Created by Watanabe Yuki on 2016/02/25.
//  Copyright © 2016 ACCESS. All rights reserved.
//

import Foundation

extension Position {

    private var index: Int {
        return i * size + j
    }

}

public struct Board<Element> {

    private var elements: [Element]

    init(element: Element) {
        elements = [Element](count: size * size, repeatedValue: element)
    }

    private init(elements: [Element]) {
        self.elements = elements
    }

    subscript(position: Position) -> Element {
        get {
            return elements[position.index]
        }
        set(element) {
            elements[position.index] = element
        }
    }

    func map<NewElement>(@noescape transform: Element throws -> NewElement)
        rethrows -> Board<NewElement> {
        let newElements = try elements.map(transform)
        return Board<NewElement>(elements: newElements)
    }

}

func possibilitiesFrom(numbers: Board<Int>) -> Board<PossibilitySet> {
    return numbers.map { (number: Int) -> PossibilitySet in
        if number >= size {
            return PossibilitySet.full()
        }
        var set = PossibilitySet()
        set.add(number)
        return set
    }
}

func numbersFrom(possibilities: Board<PossibilitySet>) -> Board<Int> {
    return possibilities.map { (set: PossibilitySet) -> Int in
        set.isUnique ? set.sum : size
    }
}
