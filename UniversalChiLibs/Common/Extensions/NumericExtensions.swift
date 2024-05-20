//
//  NumericExtensions.swift
//  UniversalChiLibs
//
//  Created by Allan Evans on 5/20/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import Foundation

extension Double {
    func roundedUp(toPlaces places: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = places
        let formattedString = numberFormatter.string(from: NSNumber(value: self)) ?? ""
        return formattedString
    }
}

