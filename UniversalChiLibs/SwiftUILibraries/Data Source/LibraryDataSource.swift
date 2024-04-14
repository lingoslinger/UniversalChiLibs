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
        // publish async network calls back to the main thread
        // eventually use @MainActor here?
        DispatchQueue.main.async {
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
