//
//  DisplayType.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 4/30/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import SwiftUI

final class DisplayType: ObservableObject {
    enum MainScreenType {
        case list
        case location
    }
    
    @Published var mainScreenType: MainScreenType = .list
}
