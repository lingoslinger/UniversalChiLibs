//
//  LibraryDataSource.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 7/14/23.
//

import SwiftUI

class LibraryDataSource: ObservableObject {
    @Published var libraries: [Library] = []
    @Published var sectionTitles: [String] = []
    
    init() {
        Task {
            await fetchData()
        }
    }

    func fetchData() async {
        do {
            self.libraries = try await WebService.getLibraryData()
            let firstLetters = self.libraries.map { $0.name.prefix(1) }
            self.sectionTitles = Array(Set(firstLetters)).map { String($0) }.sorted()
        } catch {
            fatalError("Cannot load library data")
        }
    }
}
