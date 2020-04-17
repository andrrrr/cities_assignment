//
//  City.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 17/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import Foundation
import CoreLocation

struct City: Codable {
    var country: String
    var name: String
    var _id: Int
    var coord: Coordinate

    init(country: String, name: String, _id: Int, coord: Coordinate) {
        self.country = country
        self.name = name
        self._id = _id
        self.coord = coord
    }
}

struct Coordinate: Codable {
    let lat: Double
    let lon: Double

    func locationCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat,
                                      longitude: self.lon)
    }
}
