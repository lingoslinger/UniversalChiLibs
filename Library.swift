//
//  Library.swift
//  UniversalChiLibs
//
//  Created by Allan Evans on 11/2/23.
//  Copyright © 2023 AGE Software Consulting, LLC. All rights reserved.
//

import Foundation

struct Library: Decodable {
    let address : String?
    let city : String?
    let cybernavigator : String?
    let hoursOfOperation : String?
    let location : Location?
    let name : String?
    let phone : String?
    let state : String?
    let teacherInTheLibrary : String?
    let website : Website?
    let zip : String?
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case city = "city"
        case cybernavigator = "cybernavigator"
        case hoursOfOperation = "hours_of_operation"
        case location = "location"
        case name = "name_"
        case phone = "phone"
        case state = "state"
        case teacherInTheLibrary = "teacher_in_the_library"
        case website = "website"
        case zip = "zip"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        cybernavigator = try values.decodeIfPresent(String.self, forKey: .cybernavigator)
        hoursOfOperation = try values.decodeIfPresent(String.self, forKey: .hoursOfOperation)
        location = try values.decodeIfPresent(Location.self, forKey: .location)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        teacherInTheLibrary = try values.decodeIfPresent(String.self, forKey: .teacherInTheLibrary)
        website = try values.decodeIfPresent(Website.self, forKey: .website)
        zip = try values.decodeIfPresent(String.self, forKey: .zip)
    }
}
