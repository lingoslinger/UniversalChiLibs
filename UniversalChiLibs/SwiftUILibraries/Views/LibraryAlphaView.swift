//
//  LibraryAlphaView.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 4/29/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import SwiftUI

struct LibraryAlphaView: View {
    @EnvironmentObject var dataSource: LibraryDataSource
    @EnvironmentObject var displayType: DisplayType
    @State var searchText = ""
    
    var libraries: [Library] {
        dataSource.libraries.filter {
            searchText.count == 0 ? true : $0.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    var sectionTitles: [String] {
        let firstLetters = libraries.map { $0.name.prefix(1) }
        return Array(Set(firstLetters)).map { String($0) }.sorted()
    }
    
    var showNoResultsMessage: Bool {
        searchText.count > 0 && libraries.count == 0
    }
    var body: some View {
        List {
            ForEach(sectionTitles, id: \.self) { sectionTitle in
                Section(header: Text(sectionTitle)) {
                    let currentLibraries = libraries.filter { $0.name.hasPrefix(sectionTitle) }.sorted { $0.name < $1.name }
                    ForEach(currentLibraries, id: \.self) { library in
                        LibraryItemAlpha(library: library)
                    }
                }
            }
            if showNoResultsMessage {
                Text("No results found for \"\(searchText)\"")
                    .padding()
                    .foregroundColor(.secondary)
                    .listRowBackground(Color.clear)
            }
        }
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search by library name")
        .navigationBarTitle("Chicago Libraries")
        .navigationBarItems(trailing: Button(action: { displayType.mainScreenType = .location }) {
            Image(systemName: "location") })
    }
}

#Preview {
    LibraryAlphaView()
}
