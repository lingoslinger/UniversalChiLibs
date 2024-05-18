//
//  LibraryImageView.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 4/12/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import SwiftUI
import SwiftSoup
import CoreData

struct LibraryImageView: View {
    let library: Library?
    @State private var libraryImageData: Data?
    
    var loadingBackgroundColor: Color {
        UIScreen.main.traitCollection.userInterfaceStyle == .dark ? Color.gray : Color.white
    }
    
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
                        .fill(loadingBackgroundColor)
                        .frame(height: imageHeight)
                        .onAppear {
                            Task {
                                do {
                                    try await loadLibraryImageData()
                                } catch {
                                    print("Error loading library image...")
                                }
                            }
                        }
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(minHeight: imageHeight, alignment: .center)
                        .tint(UIScreen.main.traitCollection.userInterfaceStyle == .dark ? Color.white : Color.black)
                }
            }
        }
    }
}

extension LibraryImageView {
    private func loadLibraryImageData() async throws {
        guard let library else { return }
        
        let storedImageData = getImageData(for: library)
        if storedImageData.count > 0 {
            libraryImageData = storedImageData
            return
        }

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
        
        saveImageData(imageData, for: library)
        libraryImageData = imageData
    }
    
}

extension LibraryImageView {
    func getImageData(for library: Library) -> Data {
        guard let libEntity = libraryEntity(for: library) else { return Data() }
        return libEntity.photoData ?? Data()
    }
    
    func saveImageData(_ imageData: Data, for library: Library) {
        guard let libEntity = libraryEntity(for: library) else { return }
        let context = CoreDataStack.shared.viewContext
        libEntity.photoData = imageData
        do {
            try context.save()
        } catch {
            print("Error saving to Core Data: \(error.localizedDescription)")
        }
    }
    
    func libraryEntity(for library: Library) -> LibraryEntity? {
        let context = CoreDataStack.shared.viewContext
        let request: NSFetchRequest<LibraryEntity> = LibraryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", library.name)
        let results = try? context.fetch(request)
        return results?.first
    }
}




#Preview {
    LibraryImageView(library: previewLibrary)
}
