//
//  ContentView.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 7/14/23.
//

import SwiftUI

struct LibraryView: View {
    @State var dataStore = LibraryDataSource()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataStore.sectionTitles, id: \.self) { sectionTitle in
                    Section(header: Text(sectionTitle)) {
                        let currentLibraries = dataStore.libraries.filter { $0.name.hasPrefix(sectionTitle) }.sorted { $0.name < $1.name }
                        ForEach(currentLibraries, id: \.self) { library in
                            NavigationLink(destination: LibraryDetailView(library: library)) {
                                Text(library.name)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Chicago Libraries")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
