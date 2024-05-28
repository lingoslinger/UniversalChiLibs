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
    case badHTML
}

struct WebService {
    static func getLibraryData() async throws -> [Library] {
        guard let webservicePlist = plistToDictionary(fromFile: "Webservice", ofType: "plist"),
              let prod_url = webservicePlist["prod_url"] as? String,
              let url = URL(string: prod_url) else {
            throw FetchError.badURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode < 400 else {
            throw FetchError.badResponse
        }
        guard let libraries = try? JSONDecoder().decode([Library].self, from: data) else {
            throw FetchError.badJSON
        }
        return libraries
    }
    
    static func getData(for urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else { throw FetchError.badURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode < 400 else {
            throw FetchError.badResponse
        }
        return data
    }
    
    static func getStringData(for urlString: String) async throws -> String {
            let data = try await getData(for: urlString)
            guard let returnString = String(data: data, encoding: .utf8) else {
                throw FetchError.badHTML
            }
            return returnString
        }
    
    static func getCodableData<T: Codable>(for urlString: String) async throws -> T? {
        let data = try await getData(for: urlString)
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            throw FetchError.badJSON
        }
        return decodedData
    } 
}
