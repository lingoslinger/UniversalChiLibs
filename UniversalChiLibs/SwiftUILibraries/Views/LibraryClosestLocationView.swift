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
        dataSource.libraries // eventually use user location to find closest libraries
    }
    
    var body: some View {
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
            .navigationBarItems(trailing: Button(action: { displayType.mainScreenType = .list }) { Image(systemName: "text.justify") })
        }
    }
}

#Preview {
    LibraryClosestLocationView()
}
