//
//  CityStore.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 18/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import Foundation
import Combine

class CityStore: ObservableObject {
    @Published private(set) var citiesFiltered: [City] = []
    @Published private(set) var allCitiesArray = Bundle.main.decode([City].self, from: "cities.json").sorted(by: { $0.name < $1.name })

    @Published private(set) var citiesFilteredReducedRange: Range<Int> = 0..<20
    @Published private(set) var citiesFilteredFullRange: Range<Int> = 0..<20

    @Published var searchTerm: String = "" {
        didSet {
            fetch(matching: self.searchTerm)
        }
    }

    private var treeBuilder: Tree?
    private var tree: Node?
    var isBuildingTree = true

    init(treeBuilder: Tree, halt: Bool = false) {
        self.treeBuilder = treeBuilder
        if !halt {
            buildTree()
        }

    }

    private func buildTree() {
        citiesFilteredFullRange = 0..<allCitiesArray.count

        treeBuilder?.buildTree(allCitiesArray, completed: { tree in
            self.tree = tree
            self.isBuildingTree = false
        })
    }

    func setTree(_ tree: Node) {
        self.tree = tree
    }

    func loadMore(_ chunkSize: Int) {
        let upperLimit = citiesFilteredReducedRange.upperBound + chunkSize
        DispatchQueue.main.async {
             self.citiesFilteredReducedRange = self.citiesFilteredReducedRange.lowerBound..<(min(upperLimit, self.citiesFilteredFullRange.upperBound))
        }
    }

    func fetch(matching query: String) {
        guard !query.isEmpty else {
            citiesFilteredReducedRange = 0..<20
            citiesFilteredFullRange = 0..<allCitiesArray.count

            return
        }

        search(matching: query.lowercased()) { [weak self] result in
            DispatchQueue.main.async {

                self?.citiesFilteredReducedRange = result.lowerBound..<(min(result.lowerBound + 20, (result.upperBound))) //(result.lowerBound + 20)
                self?.citiesFilteredFullRange = result

            }
        }
    }

    func search(matching searchTerm: String, handler: @escaping (Range<Int>) -> Void) {
        var searchThis = searchTerm
        var needToFilter = false
        if searchTerm.count > 3 {
            searchThis = String(searchTerm.prefix(3))
            needToFilter = true
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let searchNode = self?.tree?.search(letter: searchThis) {
                if needToFilter {
                    var newRanges = [Int]()
                    for number in searchNode.range {
                        if let match = self?.allCitiesArray[number].name.lowercased().hasPrefix(searchTerm), match == true {
                            newRanges.append(number)
                        }
                    }
                    if let minimum = newRanges.min(), let maximum = newRanges.max() {
                        DispatchQueue.main.async {
                            handler((minimum)..<(maximum + 1))
                        }
                    } else {
                        DispatchQueue.main.async {
                            handler(0..<0)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        handler(searchNode.range)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    handler(0..<1)
                }
            }
        }
    }
}

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
