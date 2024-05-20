//
//  ArrayExtensions.swift
//  UniversalChiLibs
//
//  Created by Allan Evans on 5/19/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import Foundation

extension Array {
    // Helper method to chunk an array into smaller arrays of a given size
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        for index in stride(from: 0, to: self.count, by: size) {
            let chunk = Array(self[index..<Swift.min(index + size, self.count)])
            chunks.append(chunk)
        }
        return chunks
    }
}
