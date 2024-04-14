//
//  LibraryImageView.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 4/12/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import SwiftUI
import WebKit
import SwiftSoup

struct LibraryImageView: View {
    let library: Library
    @State private var libraryImageData: Data?
    
    var body: some View {
        let imageHeight = UIScreen.main.bounds.width / 3.0 * 2.0
        VStack(alignment: .leading, spacing: 10) {
            if let data = libraryImageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minHeight: imageHeight, alignment: .center)
            } else {
                ZStack {
                    Rectangle()
                        .fill(loadingBackgroundColor())
                        .frame(height: imageHeight)
                        .onAppear {
                            Task {
                                do {
                                    try await loadLibraryImage()
                                } catch {
                                    print("Error loading library image...")
                                }
                            }
                        }
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                        Text("Loading library image...")
                            .foregroundColor(loadingTextColor())
                    }
                }
            }
        }
    }
}

extension LibraryImageView {
    private func loadLibraryImage() async throws {
        var imageURLString = ""
        
        guard let libraryURLString = library.website?.url,
              let libraryURL = URL(string: libraryURLString)
        else { fatalError("No library URL") }
        
        // TODO: add image cache check here...
        
        let (data, response) = try await URLSession.shared.data(from: libraryURL)
        guard let response = response as? HTTPURLResponse, response.statusCode < 400 else {
            fatalError("bad response")
        }
        guard let siteHTML = String(data: data, encoding: .utf8) else {
            fatalError("no html data found")
        }
        let doc = try SwiftSoup.parse(siteHTML)
        let elements: Elements = try! doc.select("meta")
        for element in elements {
            if try element.attr("property") == "og:image" {
                imageURLString = try element.attr("content")
            }
        }
        guard let imageURL = URL(string: imageURLString) else { fatalError("invalid image URL") }
        
        let (imageData, imageResponse) = try await URLSession.shared.data(from: imageURL)
        guard let imageResponse = imageResponse as? HTTPURLResponse, imageResponse.statusCode < 400 else {
            fatalError("bad response")
        }
        libraryImageData = imageData
    }
    
    private func loadingBackgroundColor() -> Color {
        return UIScreen.main.traitCollection.userInterfaceStyle == .dark ? Color.black : Color.white
    }
    
    private func loadingTextColor() -> Color {
        return UIScreen.main.traitCollection.userInterfaceStyle == .dark ? Color.white : Color.black
    }
}

#Preview {
    LibraryImageView(library: previewLibrary)
}
