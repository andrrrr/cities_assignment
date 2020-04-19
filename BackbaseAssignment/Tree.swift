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

            let root = Node(letter: "")

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
                } else {
                    print(firstLetter)
                    firstLetterNode = Node(letter: "\(firstLetter)")
                    root.add(child: firstLetterNode!)
                }

                var twoLetterNode: Node? = nil
                if city.name.count > 1 {
                    let twoLetters = city.name.prefix(2).lowercased()

                    if let twoLetterNodeFound = firstLetterNode?.searchChildren(letter: "\(twoLetters)") {
                        twoLetterNode = twoLetterNodeFound

                    } else {
                        print(twoLetters)
                        twoLetterNode = Node(letter: "\(twoLetters)")
                        firstLetterNode?.add(child: twoLetterNode!)
                    }
                }


                var threeLetterNode: Node? = nil
                if city.name.count > 2 {
                    let threeLetters = city.name.prefix(3).lowercased()

                    if let threeLetterNodeFound = twoLetterNode?.searchChildren(letter: "\(threeLetters)") {
                        threeLetterNode = threeLetterNodeFound
                        threeLetterNodeFound.addCities(city: city)
                    } else {
                        print(threeLetters)
                        threeLetterNode = Node(letter: "\(threeLetters)")
                        threeLetterNode?.addCities(city: city)
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
