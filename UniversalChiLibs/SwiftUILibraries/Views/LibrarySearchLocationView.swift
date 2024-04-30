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
    @EnvironmentObject var locationDataManager: LocationDataManager
    @State var searchText = ""
    
    var libraries: [Library] {
        dataSource.libraries // eventually use user location to find closest libraries
    }
    var body: some View {
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
            .navigationBarItems(trailing: Button(action: { displayType.mainScreenType = .list }) { Image(systemName: "text.justify") })
        }
    }
}

#Preview {
    LibrarySearchLocationView()
}
