//
//  Tree.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 19/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import Foundation

class Tree: ObservableObject {

    @Published var progressValue: Float = 0.0

    func buildTree(_ cities: [City], completed: @escaping (Node) -> Void)  {

        let citiesAllCount = cities.count
        var citiesCount = 0
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in

            let root = Node(letter: "", range: 0..<citiesAllCount)

            for city in cities {

                if citiesCount % 1000 == 0 {
                    DispatchQueue.main.async {
                        self?.progressValue = Float(citiesCount) / Float(citiesAllCount)
                    }
                }

                let firstLetter = city.name[city.name.startIndex].lowercased()
                var firstLetterNode: Node? = nil

                if let firstLetterNodeFound = root.searchChildren(letter: "\(firstLetter)") {
                    firstLetterNode = firstLetterNodeFound
                    firstLetterNode?.newUpperBound(citiesCount+1)
                } else {
                    firstLetterNode = Node(letter: "\(firstLetter)", range: citiesCount..<(citiesCount + 1))
                    root.add(child: firstLetterNode!)
                }

                var twoLetterNode: Node? = nil
                if city.name.count > 1 {
                    let twoLetters = city.name.prefix(2).lowercased()

                    if let twoLetterNodeFound = firstLetterNode?.searchChildren(letter: "\(twoLetters)") {
                        twoLetterNode = twoLetterNodeFound
                        twoLetterNode?.newUpperBound(citiesCount+1)
                    } else {
                        twoLetterNode = Node(letter: "\(twoLetters)", range: citiesCount..<(citiesCount + 1))
                        firstLetterNode?.add(child: twoLetterNode!)
                    }
                }

                var threeLetterNode: Node? = nil
                if city.name.count > 2 {
                    let threeLetters = city.name.prefix(3).lowercased()

                    if let threeLetterNodeFound = twoLetterNode?.searchChildren(letter: "\(threeLetters)") {
                        threeLetterNode = threeLetterNodeFound
                        threeLetterNode?.newUpperBound(citiesCount+1)
                    } else {
                        threeLetterNode = Node(letter: "\(threeLetters)", range: citiesCount..<(citiesCount + 1))
                        twoLetterNode?.add(child: threeLetterNode!)
                    }
                }

                citiesCount += 1
            }

            DispatchQueue.main.async {
                completed (root)
            }
        }
    }
}

class Node {
    var letter: String
    var range: Range<Int>
    var children: [Node] = []

    init(letter: String, range: Range<Int>) {
        self.letter = letter
        self.range = range
    }

    func add(child: Node) {
        children.append(child)
    }

    func newUpperBound(_ newUpperBound: Int) {
        range = range.lowerBound..<newUpperBound
    }
}

extension Node {
    func searchChildren(letter: String) -> Node? {
        for child in children {
            if let found = child.search(letter: letter) {
                return found
            }
        }
        return nil
    }

    func search(letter: String) -> Node? {
        if letter == self.letter {
            return self
        }
        return searchChildren(letter: letter)

  }
}

