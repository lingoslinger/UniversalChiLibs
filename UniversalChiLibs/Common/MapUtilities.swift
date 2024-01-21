//
//  MapUtilities.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 1/20/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import UIKit

enum MapPreference {
    case apple
    case google
    case here
}

class MapSDKChooser: ObservableObject {
    @Published var chosenMapSDK: MapPreference
    
    init(chosenMapSDK: MapPreference) {
        self.chosenMapSDK = .apple //chosenMapSDK // eventually have logic to change this based on a stored preference
    }
}


func openAppleMaps(with address: String) {
    let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let mapURLString = "http://maps.apple.com/?daddr=\(encodedAddress)&dirflg=w" // walking directions...
    
    guard let mapURL = URL(string: mapURLString) else { return }
    UIApplication.shared.open(mapURL, options: [:], completionHandler: nil)
}

