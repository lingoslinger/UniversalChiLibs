//
//  LibraryMapView.swift
//  SwiftLibrariesNoSB
//
//  Created by Allan Evans on 10/5/21.
//

import UIKit
import MapKit

class LibraryMapView: MKMapView {

    @available(*, unavailable,
                message: "LibraryMapView is not designed to be initialized from a storyboard."
    )
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    
    private func commonInit() {
        self.isScrollEnabled = false
        self.isZoomEnabled = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func annotateMap(library: Library) {
        guard let lat = library.location?.lat,
              let lon = library.location?.lon else { return }
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
