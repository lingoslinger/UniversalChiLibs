//
//  LibraryDetailView.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 7/19/23.
//

import SwiftUI

struct LibraryDetailView: View {
    let library: Library
    let mapPref = MapPreference.apple // set this somewhere else and publish 
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                switch mapPref {
                    case .apple:
                        LibraryMapView(library: library)
                            .frame(height: 300, alignment: .top)
                            .onTapGesture {
                                let searchAddress = "\(library.address ?? ""), \(library.city ?? ""), \(library.state ?? "") \(library.zip ?? "")"
                                openAppleMaps(with: searchAddress)
                            }
                            .padding(.bottom, 10)
                    case .google:
                        Text("Google maps not implemented yet")
                    case .here:
                        Text("HERE maps not implemented yet")
                }
                
                Text(library.address ?? "Address not available")
                    .padding(.leading, 10)
                LibraryPhoneNumberView(library: library)
                    .padding(.leading, 10)
                Text(library.hoursOfOperation?.formattedHours ?? "Hours not available")
                    .padding(.leading, 10)
                Spacer()
            }
            .padding(.bottom, 10)
        }
        .navigationTitle(library.name)
    }
}

struct LibraryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryDetailView(library: previewLibrary)
    }
}
