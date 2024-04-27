//
//  LocationDataSource.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 4/25/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import Foundation
import CoreLocation

class LocationDataManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var userLocation: CLLocation = CLLocation()
    @Published var locationAuthorized: CLAuthorizationStatus = .notDetermined
    
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
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAuthorized = manager.authorizationStatus
    }
}
