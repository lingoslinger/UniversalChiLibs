//
//  LibraryDataSource.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 7/14/23.
//

import SwiftUI

class LibraryDataSource: ObservableObject {
    @Published var libraries: [Library] = []
    
    init() {
        DispatchQueue.main.async { // publish async network calls back to the main thread
            Task {
                do {
                    self.libraries = try await WebService.getLibraryData()
                } catch {
                    fatalError("Cannot load library data")
                }
            }
        }
    }
}
