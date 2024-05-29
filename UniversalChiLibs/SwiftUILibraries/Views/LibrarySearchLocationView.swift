//
//  LibrarySearchLocationView.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 4/29/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import SwiftUI

struct LibrarySearchLocationView: View {
    @EnvironmentObject var dataSource: LibraryDataSource
    @EnvironmentObject var displayType: DisplayType
    @ObservedObject var locationDataManager: LocationDataManager
    @State private var searchText: String = ""
    @State private var searchQuery: String = ""
    
    var libraries: [Library] {
        if searchQuery.isEmpty {
            return []
        } else {
            return dataSource.sortedLibraries
        }
    }
    
    var body: some View {
        VStack {
            if libraries.count > 0 {
                List {
                    Section("Closest by walking distance from search location") {
                        ForEach(libraries) { library in
                            LibraryItemDistanceSorted(library: library)
                        }
                    }
                }
            } else {
                if !searchQuery.isEmpty {
                    Text("Finding walking distances - this can take up to two minutes because of MapKit API throttling limitations. Thanks Apple...🤦‍♂️")
                        .task {
                            guard let searchLoc = try? await locationDataManager.searchForLocation(searchLocation: searchQuery) else {
                                print("No location found")
                                return
                            }
                            await dataSource.fetchLibrariesSortedByDistance(from: searchLoc, maxConcurrentRequests: 49)
                        }
                }
            }
        }
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Enter an address or zip code")
        .onChange(of: searchText) { newValue in
            if searchText.isEmpty {
                searchQuery = ""
            }
        }
        .onSubmit(of: .search, {
            dataSource.clearSortedLibraries()
            searchQuery = searchText
        })
        .navigationBarTitle("Chicago Libraries")
        .navigationBarItems(trailing: Button(action: { displayType.mainScreenType = .list }) { Image(systemName: "text.justify") })
    }
}

#Preview {
    LibrarySearchLocationView(locationDataManager: LocationDataManager())
}
