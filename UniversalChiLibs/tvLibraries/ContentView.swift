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
    
    let config = [ GridItem(.adaptive(minimum: 400))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: config, spacing: 75) {
                ForEach(libraries, id: \.self) { library in
                    VStack {
                        LibraryImageView(library: library)
                            .frame(width: 300, height: 200)
                        Text(library.name)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
