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

    private(set) var citiesByLetter: [(String, [City])] = []
    private let latinAlphabet = "abcdefghijklmnopqrstuvwxyz"

    init() {
        mapAllCities()
    }

    private func mapAllCities() {
        var unfilteredCities: [(String, [City])] = []

        latinAlphabet.forEach { char in
            let char = "\(char)"
            let subset = allCitiesArray.filter { $0.name.lowercased().hasPrefix(char) }
            unfilteredCities.append((char, subset))
        }
        citiesByLetter = unfilteredCities
    }

    func splitInChunks() -> [(String, [City])] {
        return []
    }

    func fetch(matching query: String) {
        search(matching: query.lowercased()) { [weak self] result in
            DispatchQueue.main.async {
                 self?.citiesFiltered = result
            }
        }
    }

    private var previousSearchTerm = ""


    // search uses caching, 
    private func search(matching searchTerm: String, handler: @escaping ([City]) -> Void) {
        guard !searchTerm.isEmpty else { return }
        let firstChar = searchTerm[searchTerm.startIndex]

        var arrayToScan: [City]
        if !previousSearchTerm.isEmpty && searchTerm.hasPrefix(previousSearchTerm) {
            arrayToScan = citiesFiltered
        } else {
            arrayToScan = citiesByLetter.first(where:{$0.0 == "\(firstChar)"})?.1 ?? []
        }
        previousSearchTerm = searchTerm
        let arrayFound = (searchTerm.count == 1) ? arrayToScan : arrayToScan.filter {$0.name.lowercased().hasPrefix(searchTerm)}

        DispatchQueue.main.async {
            handler(arrayFound)
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
