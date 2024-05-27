//
//  MapUtilities.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 1/20/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import UIKit

func openMap(with address: String, mapPreference: MapPreference = MapPreference()) {
    let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    switch mapPreference.mapProvider {
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

func openAppleMaps(with address: String) {
    let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let mapURLString = "http://maps.apple.com/?daddr=\(encodedAddress)&dirflg=w" // walking directions...
    guard let mapURL = URL(string: mapURLString) else { return }
    UIApplication.shared.open(mapURL, options: [:], completionHandler: nil)
}

func openGoogleMaps() {
    print("Google Maps integration not complete")
}

func openHereMap() {
    print("HERE maps integration not complete")
}
