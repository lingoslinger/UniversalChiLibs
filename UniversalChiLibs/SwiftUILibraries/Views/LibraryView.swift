//
//  ContentView.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 7/14/23.
//

import SwiftUI

enum DisplayType {
    case list
    case location
}

struct LibraryView: View {
    @StateObject var dataStore = LibraryDataSource()
    @State var searchText = ""
    @State var displayType = DisplayType.list
    
    var libraries: [Library] {
        var returnLibraries = dataStore.libraries
        switch displayType {
            case .list:
                returnLibraries = dataStore.libraries.filter {
                    searchText.count == 0 ? true : $0.name.lowercased().contains(searchText.lowercased())
                }
            case .location:
                // use user location to find closest libraries
                
                returnLibraries = dataStore.libraries // for now, do distance check here eventually
        }
        return returnLibraries
    }
    
    var sectionTitles: [String] {
        let firstLetters = libraries.map { $0.name.prefix(1) }
        return Array(Set(firstLetters)).map { String($0) }.sorted()
    }
    
    var showNoResultsMessage: Bool {
        searchText.count > 0 && libraries.count == 0
    }
    
    var body: some View {
        HStack {
            NavigationView {
                switch displayType {
                    case .list:
                        List {
                            ForEach(sectionTitles, id: \.self) { sectionTitle in
                                Section(header: Text(sectionTitle)) {
                                    let currentLibraries = libraries.filter { $0.name.hasPrefix(sectionTitle) }.sorted { $0.name < $1.name }
                                    ForEach(currentLibraries, id: \.self) { library in
                                        NavigationLink(destination: LibraryDetailView(library: library)) {
                                            Text(library.name)
                                        }
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
                        .navigationBarItems(trailing:
                                                Button(action: {
                                                    print("location button pressed")
                            displayType = .location
                                                }) {
                                                    Image(systemName: "location")}
                        )
                    case .location:
                        VStack {
                            Text("Closest by walking distance")
                            List {
                                ForEach(libraries, id: \.self) { library in
                                    NavigationLink(destination: LibraryDetailView(library: library)) {
                                        Text(library.name)
                                    }
                                    
                                }
                            }
                            // TODO: make seachable if user has not given permission to use their location
//                            .searchable(text: $searchText,
//                                        placement: .navigationBarDrawer(displayMode: .always),
//                                        prompt: "Search by address or zip code")
                            .navigationBarTitle("Chicago Libraries")
                            .navigationBarItems(trailing:
                                                    Button(action: {
                                print("list button pressed")
                                displayType = .list
                            }) {
                                Image(systemName: "text.justify")}
                            )
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
