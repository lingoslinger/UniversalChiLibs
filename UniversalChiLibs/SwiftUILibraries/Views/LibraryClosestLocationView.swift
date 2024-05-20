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
    @EnvironmentObject var locationDataManager: LocationDataManager
    
    var libraries: [Library] {
        dataSource.sortedLibraries
    }
    
    var body: some View {
        VStack {
            if libraries.count > 0 {
                List {
                    Text("Closest by walking distance")
                    ForEach(libraries) { library in
                        NavigationLink(destination: LibraryDetailView(library: library)) {
                            Text("\(library.name)\n\(library.walkingDistance.roundedUp(toPlaces: 1)) mi.")
                        }
                    }
                }
            } else {
                Text("Finding walking distances - this can take up to two minutes because of MapKit API throttling limitations. Thanks Apple...🤦‍♂️")
            }
        }
        .navigationBarTitle("Chicago Libraries")
        .navigationBarItems(trailing: Button(action: { displayType.mainScreenType = .list }) { Image(systemName: "text.justify") })
    }
}

#Preview {
    LibraryClosestLocationView()
}
