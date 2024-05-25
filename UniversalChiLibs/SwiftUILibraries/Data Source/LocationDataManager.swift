//
//  LocationDataSource.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 4/25/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationDataManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var userLocation: CLLocation = CLLocation()
    private var geocoder = CLGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

extension LocationDataManager {
    var isAuthorized: Bool {
        switch (locationManager.authorizationStatus) {
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                return false
        }
    }
}

extension LocationDataManager {
    func searchForLocation(searchLocation: String) async throws -> CLLocation? {
        do {
            let placemarks = try await geocoder.geocodeAddressString(searchLocation)
            if let placemark = placemarks.first, let location = placemark.location {
                print("location found: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                return location
            } else {
                print("Cannot find location for \(searchLocation)")
            }
            return nil
        } catch {
            print("Geocoding error: \(error.localizedDescription)")
            return nil
        }
    }
}
