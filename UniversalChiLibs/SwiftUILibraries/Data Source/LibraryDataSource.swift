//
//  LibraryDataSource.swift
//  SwiftUILibraries
//
//  Created by Allan Evans on 7/14/23.
//
import CoreData
import CoreLocation
import MapKit
import Foundation
import SwiftUI

final class LibraryDataSource: ObservableObject {
    @Published var libraries: [Library] = []
    @Published var sortedLibraries: [Library] = []
    private let stack: CoreDataStack
    
    private var cacheExpired: Bool {
        let cacheLastSaved = UserDefaults.standard.double(forKey: "CacheDate")
        if cacheLastSaved == 0 { return true } // for case when cache has not been saved yet
        let today = Date().timeIntervalSince1970
        let cacheTimeInterval = 7.0 * 24.0 * 60.0 // one week for now, eventually a settable preference
        return (today - cacheLastSaved > cacheTimeInterval)
    }
    
    @MainActor init() {
        stack = CoreDataStack.shared
        Task {
            do {
                self.libraries = try await self.fetchLibraries()
            } catch {
                fatalError("Cannot load library data")
            }
        }
    }
    
    func fetchLibraries() async throws -> [Library] {
        do {
            if cacheExpired { deleteAllLibraries() }
            let cachedLibraries = try loadCachedLibraries()
            if !cachedLibraries.isEmpty {
                let libraries =  cachedLibraries.map { mapEntityToModel($0) }
                return libraries
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
    
    private func deleteAllLibraries() {
        let context = stack.viewContext
        guard let entities = context.persistentStoreCoordinator?.managedObjectModel.entities else { return }
        for entity in entities {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            do {
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                try context.execute(batchDeleteRequest)
                context.reset()
            } catch {
                print("Error deleting \(String(describing: entity.name)), \(error.localizedDescription)")
            }
        }
        do {
            try context.save()
        } catch {
            print("Error saving context after deletion, \(error.localizedDescription)")
        }
    }
    
    private func mapModelToEntity(from library: Library, to libraryEntity: LibraryEntity) {
        libraryEntity.address = library.address
        libraryEntity.city = library.city
        libraryEntity.hoursOfOperation = library.hoursOfOperation
        libraryEntity.location = locationToEntity(library.location ?? Location(latitude: "0.0", longitude: "0.0", needsRecoding: false))
        libraryEntity.name = library.name
        libraryEntity.phone = library.phone
        libraryEntity.state = library.state
        libraryEntity.website = websiteToEntity(library.website ?? Website(url: ""))
        libraryEntity.zip = library.zip
        libraryEntity.walkingDistance = library.walkingDistance
        libraryEntity.photoData = library.photoData
    }
    
    private func locationToEntity(_ location: Location) -> LocationEntity {
        let locationEntity = LocationEntity(context: stack.viewContext)
        locationEntity.lat = location.lat
        locationEntity.lon = location.lon
        locationEntity.needsRecoding = location.needsRecoding ?? false
        return locationEntity
    }
    
    private func websiteToEntity(_ website: Website) -> WebsiteEntity {
        let websiteEntity = WebsiteEntity(context: stack.viewContext)
        websiteEntity.url = website.url
        return websiteEntity
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
                       walkingDistance: libraryEntity.walkingDistance,
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

extension LibraryDataSource {
    @MainActor func fetchLibrariesSortedByDistance(from userLoc: CLLocation, maxConcurrentRequests: Int = 50) async {
        var newLibs: [Library] = []
        let libraryChunks = libraries.chunked(into: maxConcurrentRequests)
        for chunk in libraryChunks {
            // MapKit API throttles apps that make more than 50 directions requests in 60 seconds 
            // and we have 81 libraries, so we have 49 reuests every 60 seconds now
            // (1 request to get current loc in the view and 49 per chunk here)
            let chunkResults = try? await withThrowingTaskGroup(of: Library.self) { group in
                for library in chunk {
                    let libLat = library.location?.lat ?? 0.0
                    let libLon = library.location?.lon ?? 0.0
                    let libLoc = CLLocation(latitude: libLat, longitude: libLon)
                    group.addTask {
                        var newLib = library
                        let route = await self.walkingDistance(from: userLoc, to: libLoc)
                        newLib.walkingDistance = route?.distance ?? 0.0
                        print("library \(newLib.name), walking distance is \(newLib.walkingDistance) meters")
                        return newLib
                    }
                }
                
                var results: [Library] = []
                for try await result in group {
                    results.append(result)
                }
                
                return results
                
            }
            newLibs.append(contentsOf: chunkResults ?? [])
            // avoid MapKit API throttling - no more that 50 requests/minute
            if chunk != libraryChunks.last {
                try? await Task.sleep(nanoseconds: 60 * 1_000_000_000)
            }
        }
        newLibs.sort{ $0.walkingDistance < $1.walkingDistance }
        sortedLibraries = newLibs
    }
        
    func walkingDistance(from: CLLocation, to: CLLocation) async -> MKRoute? {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: from.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: to.coordinate))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        do {
            let response = try await directions.calculate()
            return response.routes.first
        } catch {
            print("Error calculating route: \(error.localizedDescription)")
            return nil
        }
    }
}
