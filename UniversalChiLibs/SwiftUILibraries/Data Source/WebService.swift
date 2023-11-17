//
//  Networker.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 11/17/23.
//

import Foundation

enum FetchError: Error {
    case badURL
    case badResponse
    case badJSON
}

struct WebService {
    static func getLibraryData() async throws -> [Library] {
        guard let webservicePlist = plistToDictionary(fromFile: "Webservice", ofType: "plist"),
              let prod_url = webservicePlist["prod_url"] as? String,
              let url = URL(string: prod_url) else {
            throw FetchError.badURL
        }
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode < 400 else {
            throw FetchError.badResponse
        }
        guard let libraries = try? JSONDecoder().decode([Library].self, from: data) else {
            throw FetchError.badJSON
        }
        return libraries
    }
}
