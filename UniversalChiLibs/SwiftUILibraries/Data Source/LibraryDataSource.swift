//
//  LibraryDataSource.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 7/14/23.
//
import CoreData
import SwiftUI

final class LibraryDataSource: ObservableObject {
    @Published var libraries: [Library] = []
    private let stack: CoreDataStack
    
    init() {
        stack = CoreDataStack.shared
        DispatchQueue.main.async {
            Task {
                do {
                    self.libraries = try await self.fetchLibraries()
                } catch {
                    fatalError("Cannot load library data")
                }
            }
        }
    }
    
    func fetchLibraries() async throws -> [Library] {
        do {
            let cachedLibraries = try loadCachedLibraries()
            if !cachedLibraries.isEmpty {
                let cacheInterval: Double = UserDefaults.standard.double(forKey: "CacheDate")
                let cacheDate = Date(timeIntervalSince1970: cacheInterval)
                print("Cache date is \(String(describing: cacheDate))")
                return cachedLibraries.map { mapEntityToModel($0)}
            } else {
                let libraries = try await WebService.getLibraryData()
                let timeInterval: Double = Date().timeIntervalSince1970
                UserDefaults.standard.set(timeInterval, forKey: "CacheDate")
                await saveToCoreData(libraries)
                return libraries
            }
        } catch {
            print("Error getting libraries: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func loadCachedLibraries() throws -> [LibraryEntity] {
        let request: NSFetchRequest<LibraryEntity> = LibraryEntity.fetchRequest()
        return try stack.viewContext.fetch(request)
    }
    
    private func saveToCoreData(_ libraries: [Library]) async {
        let context = stack.viewContext
        await context.perform {
            for library in libraries {
                let libraryEntity = LibraryEntity(context: context)
                self.mapModelToEntity(from: library, to:libraryEntity)
            }
            do {
                try context.save()
            } catch {
                print("Error saving to Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    // TODO:
    // - method to completely wipe core data store (for reloading cache)
    
    private func saveImageData(_ imageData: Data, to libraryEntity: LibraryEntity) {
        libraryEntity.photoData = imageData
    }
    
    private func mapModelToEntity(from library: Library, to libraryEntity: LibraryEntity) {
        libraryEntity.address = library.address
        libraryEntity.city = library.city
        libraryEntity.hoursOfOperation = library.hoursOfOperation
        locationToEntity(library, libraryEntity: libraryEntity)
        libraryEntity.name = library.name
        libraryEntity.phone = library.phone
        libraryEntity.state = library.state
        libraryEntity.website?.url = library.website?.url
        libraryEntity.zip = library.zip
        libraryEntity.photoURL = library.photoURL
        libraryEntity.photoData = library.photoData
    }
    
    private func locationToEntity(_ library: Library, libraryEntity: LibraryEntity) {
        let libloc = library.location ?? Location(latitude: "0.0", longitude: "0.0", needsRecoding: false)
        libraryEntity.location?.lat = Double(libloc.latitude ?? "0.0") ?? 0.0
        libraryEntity.location?.lon = Double(libloc.longitude ?? "0.0") ?? 0.0
        libraryEntity.location?.needsRecoding = libloc.needsRecoding ?? false
    }
    
    private func mapEntityToModel(_ libraryEntity: LibraryEntity) -> Library {
        return Library(address: libraryEntity.address ?? "",
                       city: libraryEntity.city ?? "",
                       hoursOfOperation: libraryEntity.hoursOfOperation ?? "",
                       location: locationFromEntity(libraryEntity),
                       name: libraryEntity.name ?? "",
                       phone: libraryEntity.phone ?? "",
                       state: libraryEntity.state ?? "",
                       website: websiteFromEntity(libraryEntity),
                       zip: libraryEntity.zip ?? "",
                       photoURL: libraryEntity.photoURL ?? "",
                       photoData: libraryEntity.photoData ?? Data())
    }
    
    private func locationFromEntity(_ libraryEntity: LibraryEntity) -> Location {
        let latString = String(libraryEntity.location?.lat ?? 0.0)
        let lonString = String(libraryEntity.location?.lon ?? 0.0)
        let needsRecoding = libraryEntity.location?.needsRecoding
        return Location(latitude: latString, longitude: lonString, needsRecoding: needsRecoding)
    }
    
    private func websiteFromEntity(_ libraryEntity: LibraryEntity) -> Website {
        return Website(url: libraryEntity.website?.url)
    }
}
