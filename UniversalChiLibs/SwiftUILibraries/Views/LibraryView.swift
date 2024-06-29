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
    
    var body: some View {
        NavigationView {
            switch displayType.mainScreenType {
                case .list:
                    LibraryAlphaView()
                case .location: 
                    if locationDataManager.isAuthorized {
                        LibraryLocationView()
                    } else {
                        LibrarySearchLocationView()
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
