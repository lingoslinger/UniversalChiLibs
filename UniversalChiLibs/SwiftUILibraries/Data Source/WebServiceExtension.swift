//
//  WebServiceExtension.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 11/17/23.
//

import Foundation
import WebService

extension WebService {
    static func getLibraryData() async throws -> [Library] {
        guard let webservicePlist = plistToDictionary(fromFile: "Webservice", ofType: "plist"),
              let prod_url = webservicePlist["prod_url"] as? String else {
            throw FetchError.badURL
        }
        let libraries: [Library] = try await getJSONData(for: prod_url)
        return libraries
    }
}
