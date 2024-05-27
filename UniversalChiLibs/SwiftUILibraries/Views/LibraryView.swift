//
//  ContentView.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 7/14/23.
//

import SwiftUI
import CoreLocation

struct LibraryView: View {
    @EnvironmentObject var displayType: DisplayType
    @StateObject var locationDataManager = LocationDataManager()
    
    
    var body: some View {
        NavigationView {
            switch displayType.mainScreenType {
                case .list:
                    LibraryAlphaView()
                case .location:
                    // TODO: maybe make this one view again?
                    if locationDataManager.isAuthorized {
                        LibraryClosestLocationView(locationDataManager: locationDataManager)
                    } else {
                        LibrarySearchLocationView(locationDataManager: locationDataManager)
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
