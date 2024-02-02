//
//  MapUtilities.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 1/20/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import UIKit

// think about this some more before implementing...
enum MapPreference: String {
    case apple = "Apple"
    case google = "Google"
    case here = "HERE"
}

var mapPreference = MapPreference.apple // TODO: ability to change preference

func openMap(with address: String) {
    let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    switch mapPreference {
        case .apple:
            let mapURLString = "http://maps.apple.com/?daddr=\(encodedAddress)&dirflg=w" // walking directions...
            guard let mapURL = URL(string: mapURLString) else { return }
            UIApplication.shared.open(mapURL, options: [:], completionHandler: nil)
        case .google:
            print("Google Maps integration not complete")
        case .here:
            print("HERE maps integration not complete")
    }
}
