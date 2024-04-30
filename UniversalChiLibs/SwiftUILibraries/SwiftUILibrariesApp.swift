//
//  SwiftUILibrariesApp.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 7/14/23.
//

import SwiftUI

@main
struct SwiftUILibrariesApp: App {
    @StateObject var displayType = DisplayType()
    @StateObject var dataSource = LibraryDataSource()
    @StateObject var locationDataManager = LocationDataManager()
    
    var body: some Scene {
        WindowGroup {
            LibraryView()
                .environmentObject(displayType)
                .environmentObject(dataSource)
                .environmentObject(locationDataManager)
        }
    }
}
