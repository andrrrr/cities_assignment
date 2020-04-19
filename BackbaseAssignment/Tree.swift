//
//  Tree.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 19/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import Foundation

class Tree {

    init(allCities: [City]) {
        buildTree(allCities)
    }

    func buildTree(_ cities: [City]) {
        let citiesSorted = cities.sorted(by: { $0.name < $1.name })
        let root = Node(letter: "", cities: [])
        for city in citiesSorted {
            let firstLetter = city.name[city.name.startIndex]
            var firstLetterNode: Node? = nil
            if root.search(letter: "\(firstLetter)") == nil {
                firstLetterNode = Node(letter: "\(firstLetter)")
                root.add(child: firstLetterNode!)
            }

            let twoLetters = city.name.index(city.name.startIndex, offsetBy: 2)
            var twoLetterNode: Node? = nil
            if firstLetterNode?.search(letter: "\(twoLetters)") == nil {
                twoLetterNode = Node(letter: "\(twoLetters)")
                firstLetterNode?.add(child: twoLetterNode!)
            }

            let threeLetters = city.name.index(city.name.startIndex, offsetBy: 3)
            var threeLetterNode: Node? = nil
            if let threeLetterNodeFound = twoLetterNode?.search(letter: "\(threeLetters)") {
                threeLetterNodeFound.addCities(city: city)
            } else {
                threeLetterNode = Node(letter: "\(threeLetters)")
                threeLetterNode?.addCities(city: city)
                twoLetterNode?.add(child: threeLetterNode!)
            }
        }

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
