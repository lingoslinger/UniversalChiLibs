//
//  LibraryMapView.swift
//  SwiftLibrariesNoSB
//
//  Created by Allan Evans on 10/5/21.
//

import UIKit
import MapKit

class LibraryMapView: MKMapView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func annotateMap(library: Library) {
        guard let latitudeString = library.location?.latitude,
              let longitudeString = library.location?.longitude,
              let lat = Double(latitudeString),
              let lon = Double(longitudeString) else { return }
        let zoomLocation = CLLocationCoordinate2D.init(latitude: lat,
                                                       longitude: lon)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let viewRegion = MKCoordinateRegion.init(center: zoomLocation, span: span)
        let point = MKPointAnnotation.init()
        point.coordinate = zoomLocation
        point.title = library.name
        self.addAnnotation(point)
        self.setRegion(self.regionThatFits(viewRegion), animated: true)
    }
}
