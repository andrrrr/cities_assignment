//
//  City.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 17/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import Foundation
import CoreLocation

struct City: Codable, Identifiable {
    var id: Int
    var country: String
    var name: String
    var coord: Coordinate

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case country = "country"
        case name = "name"
        case coord = "coord"
    }

    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            country = try container.decode(String.self, forKey: .country)
            name = try container.decode(String.self, forKey: .name)
            coord = try container.decode(Coordinate.self, forKey: .coord)

    }
}

struct Coordinate: Codable, Hashable {
    let lat: Double
    let lon: Double

    func locationCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat,
                                      longitude: self.lon)
    }

    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.lat == rhs.lat &&  lhs.lon == rhs.lon
    }
}


