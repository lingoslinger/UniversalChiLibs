//
//  LibraryDetailView.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 7/19/23.
//

import SwiftUI

struct LibraryDetailView: View {
    let library: Library
    @State private var mapPreference = MapPreference.apple // set this somewhere else and publish?
    @State private var libraryImageData: Data?

    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    LibraryImageView(library: library)
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
