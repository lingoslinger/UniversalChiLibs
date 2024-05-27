//
//  MapPreference.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 5/26/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import Foundation

final class MapPreference: ObservableObject {
    enum MapPreference: String {
        case apple = "Apple"
        case google = "Google"
        case here = "HERE"
    }

    @Published var mapProvider: MapPreference = .apple
}
