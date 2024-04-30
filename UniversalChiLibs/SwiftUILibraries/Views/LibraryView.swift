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
    @EnvironmentObject var locationDataManager: LocationDataManager
    
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
                switch displayType.mainScreenType {
                    case .list:
                        LibraryAlphaView()
                    case .location:
                        if locationAuthorized {
                            LibraryClosestLocationView()
                        } else {
                            LibrarySearchLocationView()
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
