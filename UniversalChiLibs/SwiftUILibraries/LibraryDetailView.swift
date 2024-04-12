//
//  LibraryDetailView.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 7/19/23.
//

import SwiftUI
import WebKit
import SwiftSoup

struct LibraryDetailView: View {
    let library: Library
    @State private var mapPreference = MapPreference.apple // set this somewhere else and publish?
    @State private var libraryImageData: Data?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    if let data = libraryImageData, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minHeight: 200, alignment: .center)
                    } else {
                        Text("Loading library image")
                            .frame(alignment: .center)
                            .onAppear {
                                Task {
                                    do {
                                        try await loadLibraryImage()
                                    } catch {
                                        print("Error loading library image...")
                                    }
                                }
                            }
                    }
                    Text(library.address ?? "Address not available")
                        .padding(.leading, 10)
                    LibraryPhoneNumberView(library: library)
                        .padding(.leading, 10)
                    Text(library.hoursOfOperation?.formattedHours ?? "Hours not available")
                        .padding(.leading, 10)
                    switch mapPreference {
                        case .apple:
                            LibraryAppleMapView(library: library)
                                .frame(height: 200, alignment: .top)
                                .onTapGesture {
                                    let searchAddress = "\(library.address ?? ""), \(library.city ?? ""), \(library.state ?? "") \(library.zip ?? "")"
                                    openMap(with: searchAddress)
                                }
                                .gesture(
                                    LongPressGesture(minimumDuration: 1.0)
                                        .onChanged { _ in
                                            print("Long press detected, do what you will with it")
                                        }
                                )
                                .padding(.bottom, 10)
                        case .google:
                            LibraryGoogleMapView()
                                .frame(height: 300, alignment: .top)
                        case .here:
                            LibraryHereMapView()
                                .frame(height: 300, alignment: .top)
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
            }
        }
        .navigationTitle(library.name)
    }
}

struct LibraryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryDetailView(library: previewLibrary)
    }
}

extension LibraryDetailView {
    func loadLibraryImage() async throws {
        var imageURLString = ""
        
        guard let libraryURLString = library.website?.url,
              let libraryURL = URL(string: libraryURLString)
        else { fatalError("No library URL") }
        
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
}
