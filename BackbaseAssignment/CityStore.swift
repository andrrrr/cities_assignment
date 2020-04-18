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
    @Published private(set) var cities: [City] = []

    private let service: CityService
    init(service: CityService) {
        self.service = service
    }

    func fetch(matching query: String) {
        service.search(matching: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.cities = result
            }
        }
    }
}
