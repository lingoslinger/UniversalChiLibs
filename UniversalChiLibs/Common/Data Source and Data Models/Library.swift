//
//  Library.swift
//  UniversalChiLibs
//
//  Created by Allan Evans on 11/2/23.
//  Copyright © 2023 AGE Software Consulting, LLC. All rights reserved.
//

import Foundation

struct Library: Decodable, Identifiable, Hashable {
    let address : String?
    let city : String?
    let hoursOfOperation : String?
    let location : Location?
    let name : String
    let phone : String?
    let state : String?
    let website : Website?
    let zip : String?
    var photoURL: String = ""
    var photoData: Data = Data()
    let id: Int = UUID().hashValue
    
    // using Decodable and coding keys here because of some naming issues in the data source
    // I'm looking at you, "name_" 🤦‍♂️
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case city = "city"
        case hoursOfOperation = "hours_of_operation"
        case location = "location"
        case name = "name_"
        case phone = "phone"
        case state = "state"
        case website = "website"
        case zip = "zip"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        hoursOfOperation = try values.decodeIfPresent(String.self, forKey: .hoursOfOperation)
        location = try values.decodeIfPresent(Location.self, forKey: .location)
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        website = try values.decodeIfPresent(Website.self, forKey: .website)
        zip = try values.decodeIfPresent(String.self, forKey: .zip)
    }
    
    init(address: String, city: String, hoursOfOperation: String, location: Location, name: String, phone: String, state: String, website: Website, zip: String, photoURL: String, photoData: Data) {
        self.address = address
        self.city = city
        self.hoursOfOperation = hoursOfOperation
        self.location = location
        self.name = name
        self.phone = phone
        self.state = state
        self.website = website
        self.zip = zip
        self.photoURL = photoURL
        self.photoData = photoData
    }
}

//extension Library {
    struct Location: Codable {
        let latitude: String?
        let longitude: String?
        let needsRecoding: Bool?
        
        init(latitude: String?, longitude: String?, needsRecoding: Bool?) {
            self.latitude = latitude
            self.longitude = longitude
            self.needsRecoding = needsRecoding
        }
        
        var lat: Double {
            // both the string and the Double we create from it are optional so 🤷‍♂️
            Double(latitude ?? "0.0") ?? 0.0
        }
        var lon: Double {
            Double(longitude ?? "0.0") ?? 0.0
        }
    }

    struct Website: Codable {
        let url: String?
        
        init(url: String?) {
            self.url = url
        }
    }
//}

extension Library {
    static func == (lhs: Library, rhs: Library) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
