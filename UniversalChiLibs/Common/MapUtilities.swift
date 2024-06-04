//
//  MapUtilities.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 1/20/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import UIKit
import SwiftUI
import MapKit
import CoreLocation

// TODO: replace this legacy code for the UIKit apps,
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

func openAppleMaps(for library: Library) {
    // TODO: starting location
    // location permission given: use user location
    // no location permission: store search location as a StateObject in the search screen and use that
    var startLoc: CLLocation?
    
    let libLat = library.location?.lat ?? 0.0
    let libLon = library.location?.lon ?? 0.0
    let libLoc = CLLocation(latitude: libLat, longitude: libLon)
    
    var mapItems: [MKMapItem] = []
    if let startLoc {
        mapItems.append(MKMapItem(placemark: MKPlacemark(coordinate: startLoc.coordinate)))
    }
    mapItems.append(MKMapItem(placemark: MKPlacemark(coordinate: libLoc.coordinate)))
    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
    MKMapItem.openMaps(with: mapItems, launchOptions: launchOptions)
}

func openGoogleMaps() {
    print("Google Maps integration not complete")
}

func openHereMap() {
    print("HERE maps integration not complete")
}
