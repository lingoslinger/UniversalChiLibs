//
//  ContentView.swift
//  tvLibraries
//
//  Created by Allan Evans on 4/15/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject var dataStore = LibraryDataSource()
   
    var libraries: [Library] {
        dataStore.libraries
    }
    
    let config = [ GridItem(.adaptive(minimum: 350))]
    
    var body: some View {
        ScrollView {
            Text("Chicago Libraries")
                .font(.headline)
            LazyVGrid(columns: config, spacing: 75) {
                ForEach(libraries, id: \.self) { library in
                    tvLibraryView(library: library)
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
