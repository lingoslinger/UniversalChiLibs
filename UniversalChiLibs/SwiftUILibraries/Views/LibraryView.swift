//
//  ContentView.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 7/14/23.
//

import SwiftUI
import CoreLocation

enum DisplayType {
    case list
    case location
}

struct LibraryView: View {
    @StateObject var dataStore = LibraryDataSource()
    @State var searchText = ""
    @State var displayType = DisplayType.list
    @StateObject var locationDataManager = LocationDataManager()
    
    var libraries: [Library] {
        var returnLibraries = dataStore.libraries
        switch displayType {
            case .list:
                returnLibraries = dataStore.libraries.filter {
                    searchText.count == 0 ? true : $0.name.lowercased().contains(searchText.lowercased())
                }
            case .location:
                // eventually use user location to find closest libraries
                
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
    
    var locationAuthorized: Bool {
        let authorized = locationDataManager.locationAuthorized
        switch (authorized) {
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                return false
        }
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
                        .navigationBarItems(trailing: Button(action: { displayType = .location }) {
                            Image(systemName: "location") })
                    case .location:
                        if locationAuthorized {
                            VStack {
                                Text("User location: \(locationDataManager.userLocation.coordinate)")
                                Text("Closest by walking distance")
                                // TODO: sort libraries by walking distance from user location here
                                List {
                                    ForEach(libraries, id: \.self) { library in
                                        NavigationLink(destination: LibraryDetailView(library: library)) {
                                            Text(library.name)
                                        }
                                        
                                    }
                                }
                                .navigationBarTitle("Chicago Libraries")
                                .navigationBarItems(trailing: Button(action: { displayType = .list }) { Image(systemName: "text.justify") })
                            }
                        } else {
                            VStack {
                                Text("Use of user location not authorized")
                                Text("Closest by walking distance")
                                // TODO: use entered data to get location to sort libraries here
                                List {
                                    ForEach(libraries, id: \.self) { library in
                                        NavigationLink(destination: LibraryDetailView(library: library)) {
                                            Text(library.name)
                                        }
                                        
                                    }
                                }
                                // TODO: make searchable if user has not given permission to use their location
                                .searchable(text: $searchText,
                                            placement: .navigationBarDrawer(displayMode: .always),
                                            prompt: "Enter an address or zip code")
                                .navigationBarTitle("Chicago Libraries")
                                .navigationBarItems(trailing: Button(action: { displayType = .list }) { Image(systemName: "text.justify") })
                            }
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
