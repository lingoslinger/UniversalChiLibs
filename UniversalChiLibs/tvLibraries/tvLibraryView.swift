//
//  tvLibraryView.swift
//  tvLibraries
//
//  Created by Allan Evans on 4/16/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import SwiftUI

struct tvLibraryView: View {
    var library: Library
    
    var body: some View {
        Button(action: {
            print("Selected library: \(library)")
        }) {
            VStack {
                LibraryImageView(library: library)
                    .frame(width: 300, height: 200)
                Text(library.name)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    tvLibraryView(library: previewLibrary)
}
