//
//  LibraryDataSource.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 7/14/23.
//

import Foundation

class LibraryDataSource: ObservableObject {
    @Published var libraries: [Library] = []
    @Published var sectionTitles: [String] = []
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        guard let url = URL(string: "https://data.cityofchicago.org/resource/x8fc-8rcq.json") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([Library].self, from: data)
                DispatchQueue.main.async {
                    self.libraries = decodedData
                    let firstLetters = Set(self.libraries.compactMap{ $0.name.first }).sorted()
                    self.sectionTitles = Array(firstLetters.map { String($0) })
                }
            } catch {
                print("Error decoding data: \(error)")
            }
            
        }.resume()
    }
}
