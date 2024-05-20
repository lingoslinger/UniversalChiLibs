//
//  LibraryClosestLocationView.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 4/29/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import SwiftUI
import CoreLocation

struct LibraryClosestLocationView: View {
    @EnvironmentObject var dataSource: LibraryDataSource
    @EnvironmentObject var displayType: DisplayType
    
    var libraries: [Library] {
        dataSource.sortedLibraries // eventually use user location to find closest libraries
    }
    
    var body: some View {
        VStack {
            if libraries.count > 0 {
                Text("Closest by walking distance")
                List {
                    ForEach(libraries, id: \.self) { library in
                        NavigationLink(destination: LibraryDetailView(library: library)) {
                            HStack {
                                Text(library.name)
                                Text("\(library.walkingDistance) mi.")
                            }
                        }
                        
                    }
                }
            } else {
                Text("Finding walking distances - this can take up to two minutes because of API throttling limitations")
            }
        }
        .navigationBarTitle("Chicago Libraries")
        .navigationBarItems(trailing: Button(action: { displayType.mainScreenType = .list }) { Image(systemName: "text.justify") })
    }
}

#Preview {
    LibraryClosestLocationView()
}
