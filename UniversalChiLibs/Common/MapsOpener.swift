//
//  MapsOpener.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 1/20/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import UIKit

func openAppleMaps(with address: String) {
    let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let mapURLString = "http://maps.apple.com/?daddr=\(encodedAddress)&dirflg=w" // walking directions...
    
    guard let mapURL = URL(string: mapURLString) else { return }
    UIApplication.shared.open(mapURL, options: [:], completionHandler: nil)
}

