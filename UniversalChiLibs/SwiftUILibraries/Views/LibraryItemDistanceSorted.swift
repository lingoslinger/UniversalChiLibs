//
//  LibraryItemDistanceSorted.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 5/22/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import SwiftUI

struct LibraryItemDistanceSorted: View {
    let library: Library
    
    var metric: Bool {
        if #available(iOS 16, *) {
            return !(Locale.current.measurementSystem == .us || Locale.current.measurementSystem == .uk)
        } else {
            var isMetric = true
            if let regionCode = Locale.current.regionCode {
                switch regionCode {
                    case "US", "LR", "MM", "GB":
                        isMetric = false
                    default:
                        isMetric = true
                }
            }
            return isMetric
        }
    }
    
    var body: some View {
        let divisor = (metric ? 1000.0 : 1609.344)
        let unit = (metric ? "km" : "mi")
        
        let miles = library.walkingDistance / divisor
        let formattedDistance = miles.formatted(
            .number
                .rounded(rule: .up, increment: 0.1)
        )
        NavigationLink(destination: LibraryDetailView(library: library)) {
            Text("\(library.name)\n\(formattedDistance) \(unit)")
        }
    }
    
}

#Preview {
    LibraryItemDistanceSorted(library: previewLibrary)
}
