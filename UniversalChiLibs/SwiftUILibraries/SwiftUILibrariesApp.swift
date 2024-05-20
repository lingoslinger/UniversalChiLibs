//
//  SwiftUILibrariesApp.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 7/14/23.
//

import SwiftUI

@main
struct SwiftUILibrariesApp: App {
    @StateObject var locationDataManager = LocationDataManager()
    @StateObject var displayType = DisplayType()
    @StateObject var dataSource = LibraryDataSource()
    
    var body: some Scene {
        WindowGroup {
            LibraryView()
                .environmentObject(locationDataManager)
                .environmentObject(displayType)
                .environmentObject(dataSource)
        }
    }
}
