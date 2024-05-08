//
//  Location.swift
//  UniversalChiLibs
//
//  Created by Allan Evans on 11/2/23.
//  Copyright © 2023 AGE Software Consulting, LLC. All rights reserved.
//

import Foundation

struct Location: Decodable {
    let latitude: String?
    let longitude: String?
    let needsRecoding: Bool?
    let lat: Double?
    let lon: Double?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case needsRecoding = "needs_recoding"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        needsRecoding = try values.decodeIfPresent(Bool.self, forKey: .needsRecoding)
        lat = Double(latitude ?? "0.0")
        lon = Double(longitude ?? "0.0")
    }
}
