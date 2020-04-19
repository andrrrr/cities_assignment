//
//  Tree.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 19/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import Foundation

class Tree {

    static func buildTree(_ cities: [City]) -> Node {

        let root = Node(letter: "", cities: [])
        for city in cities {
            let firstLetter = city.name[city.name.startIndex].lowercased()
            var firstLetterNode: Node? = nil

            if let firstLetterNodeFound = root.search(letter: "\(firstLetter)") {
                firstLetterNode = firstLetterNodeFound
            } else {
                firstLetterNode = Node(letter: "\(firstLetter)")
                root.add(child: firstLetterNode!)
            }

            var twoLetterNode: Node? = nil
            if city.name.count > 1 {
                let twoLetters = city.name.prefix(2).lowercased()

                if let twoLetterNodeFound = firstLetterNode?.search(letter: "\(twoLetters)") {
                    twoLetterNode = twoLetterNodeFound

                } else {
                    twoLetterNode = Node(letter: "\(twoLetters)")
                    firstLetterNode?.add(child: twoLetterNode!)
                }
            }


            var threeLetterNode: Node? = nil
            if city.name.count > 2 {
                let threeLetters = city.name.prefix(3).lowercased()

                if let threeLetterNodeFound = twoLetterNode?.search(letter: "\(threeLetters)") {
                    threeLetterNode = threeLetterNodeFound
                    threeLetterNodeFound.addCities(city: city)
                } else {
                    threeLetterNode = Node(letter: "\(threeLetters)")
                    threeLetterNode?.addCities(city: city)
                    twoLetterNode?.add(child: threeLetterNode!)
                }
            }
        }

        return root

    }
}

class Node {
    var letter: String
    var cities: [City]?
    var children: [Node] = []

    init(letter: String, cities: [City]? = nil) {
        self.letter = letter
        self.cities = cities
    }

    func add(child: Node) {
        children.append(child)
    }

    func addCities(city: City) {
        if cities != nil {
            cities!.append(city)
        } else {
            cities = [city]
        }
    }
}

extension Node {
    func search(letter: String) -> Node? {
        if letter == self.letter {
            return self
        }
        for child in children {
            if let found = child.search(letter: letter) {
                return found
            }
        }
        return nil
  }
}

extension Node {
    func allCitiesUnder(letter: String) -> [City] {
        if self.cities != nil {
            return self.cities!
        } else {
            var citiesAccum = [City]()
            for child in children {
                citiesAccum += child.allCitiesUnder(letter: self.letter)
            }
            return citiesAccum
        }
    }
}
