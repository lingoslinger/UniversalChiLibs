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
    case badString
    case badImage
}

struct WebService {
    static func getData(for urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else { throw FetchError.badURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode < 400 else {
            throw FetchError.badResponse
        }
        return data
    }
    
    static func getStringForData(at urlString: String) async throws -> String {
            let data = try await getData(for: urlString)
            guard let returnString = String(data: data, encoding: .utf8) else {
                throw FetchError.badString
            }
            return returnString
        }
    
    static func getJSONData<T: Decodable>(for urlString: String) async throws -> [T] {
        let data = try await getData(for: urlString)
        guard let decodedData = try? JSONDecoder().decode([T].self, from: data) else {
            throw FetchError.badJSON
        }
        return decodedData
    }
}

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
