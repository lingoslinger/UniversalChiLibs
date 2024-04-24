//
//  ContentView.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 7/14/23.
//

import SwiftUI

enum DisplayType {
    case list
    case closestLocation
}

struct LibraryView: View {
    @State var displayType = DisplayType.list
    
    var body: some View {
        switch displayType {
            case .list:
                LibraryAlphaNavigationView()
            case .closestLocation:
                Text("Location View goes here")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
