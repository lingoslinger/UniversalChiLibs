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
        let address = detailLibrary?.address ?? ""
        let city = detailLibrary?.city ?? ""
        let state = detailLibrary?.state ?? ""
        let zip = detailLibrary?.zip ?? ""
        libraryAddressLabel.text = "\(address) \(city), \(state) \(zip)"
        libraryHoursLabel.text = detailLibrary?.hoursOfOperation?.formattedHours ?? "Library hours unavailable"
        annotateMap()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap))
        libraryMapView.addGestureRecognizer(tapGesture)
    }
    
    private func annotateMap() {
        let lat = detailLibrary?.location?.lat ?? 0.0
        let lon = detailLibrary?.location?.lon ?? 0.0
        let zoomLocation = CLLocationCoordinate2D.init(latitude: lat, longitude: lon)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let viewRegion = MKCoordinateRegion.init(center: zoomLocation, span: span)
        let point = MKPointAnnotation.init()
        point.coordinate = zoomLocation
        point.title = detailLibrary?.name
        libraryMapView.addAnnotation(point)
        libraryMapView.setRegion(libraryMapView.regionThatFits(viewRegion), animated: true)
    }
    
    @objc private func handleMapTap() {
        let address = detailLibrary?.address ?? ""
        let city = detailLibrary?.city ?? ""
        let state = detailLibrary?.state ?? ""
        let zip = detailLibrary?.zip ?? ""
        
        let searchAddress = "\(address), \(city), \(state) \(zip)"
        openMap(with: searchAddress)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let view = LibraryImageView(library: detailLibrary)
        if let controller = segue.destination as? LibraryImageViewController {
            controller.rootView = view
            controller.view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
