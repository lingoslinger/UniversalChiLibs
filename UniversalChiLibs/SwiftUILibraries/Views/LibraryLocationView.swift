//
//  LibraryClosestLocationView.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 4/29/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import SwiftUI
import CoreLocation

struct LibraryLocationView: View {
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
                    Section("Closest by walking distance") {
                        ForEach(libraries) { library in
                            LibraryItemDistanceSorted(library: library)
                        }
                    }
                }
            } else {
                // TODO: loading indicator here also...
                Text("Finding walking distances from current location - this can take up to two minutes because of MapKit API throttling limitations. Thanks Apple...🤦‍♂️")
                    .task {
                        guard let userLocation = locationDataManager.userLocation else {
                            return
                        }
                        await dataSource.fetchLibrariesSortedByDistance(from: userLocation, maxConcurrentRequests: 49)
                    }
            }
        }
        .navigationBarTitle("Chicago Libraries")
        .navigationBarItems(trailing: Button(action: { displayType.mainScreenType = .list }) { Image(systemName: "text.justify") })
    }
}

#Preview {
    LibraryLocationView()
}
