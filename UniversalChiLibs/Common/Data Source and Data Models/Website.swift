//
//  Website.swift
//  UniversalChiLibs
//
//  Created by Allan Evans on 11/2/23.
//  Copyright © 2023 AGE Software Consulting, LLC. All rights reserved.
//

import Foundation

struct Website: Decodable {
    let url: String?
   
    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url)
    }
}
