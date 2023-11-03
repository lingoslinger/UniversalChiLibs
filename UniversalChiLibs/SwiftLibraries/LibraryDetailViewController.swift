//
//  LibraryDetailViewController.swift
//  UniversalChiLibs
//
//  Created by Allan Evans on 11/2/23.
//

import UIKit
import Foundation
import MapKit

class LibraryDetailViewController: UIViewController {
    
    @IBOutlet weak var libraryPhoneTextView: UITextView!
    @IBOutlet weak var libraryAddressLabel: UILabel!
    @IBOutlet weak var libraryHoursLabel: UILabel!
    @IBOutlet weak var libraryMapView: MKMapView!
    
    var detailLibrary : Library?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = detailLibrary?.name ?? "Library name not available"
        let phone = detailLibrary?.phone ?? "Library phone unavailable"
        libraryPhoneTextView.text = "Phone: \(phone)"
        libraryAddressLabel.text = detailLibrary?.address ?? "Library address unavailable"
        libraryHoursLabel.text = detailLibrary?.hoursOfOperation?.formattedHours ?? "Library hours unavailable"
        annotateMap()
    }
    
    
    func annotateMap() {
        let latitudeString = detailLibrary?.location?.latitude ?? ""
        let longitudeString = detailLibrary?.location?.longitude ?? ""
        let zoomLocation = CLLocationCoordinate2D.init(latitude: Double(latitudeString) ?? 0.0, longitude: Double(longitudeString) ?? 0.0)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let viewRegion = MKCoordinateRegion.init(center: zoomLocation, span: span)
        let point = MKPointAnnotation.init()
        point.coordinate = zoomLocation
        point.title = detailLibrary?.name
        libraryMapView.addAnnotation(point)
        libraryMapView.setRegion(libraryMapView.regionThatFits(viewRegion), animated: true)
    }
}
