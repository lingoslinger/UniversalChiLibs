//
//  LibraryDetailViewController.swift
//  SwiftLibrariesNoSB
//
//  Created by Allan Evans on 9/22/21.
//

import UIKit
import MapKit

class LibraryDetailViewController: UIViewController {
    
    var library: Library?
    
    convenience init(library: Library) {
        self.init()
        self.library = library
    }
    
    private let mapView = LibraryMapView()
    private let addressLabel = LibraryLabel()
    private let hoursLabel = LibraryLabel(numberOfLines: 0)
    private let phoneTextView = LibraryPhoneTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .white
        } else {
            view.backgroundColor = .black
        }
        view.addSubview(mapView)
        view.addSubview(addressLabel)
        view.addSubview(phoneTextView)
        view.addSubview(hoursLabel)
        setupAutoLayout()
        setupUI()
    }
    
    private func setupAutoLayout() {
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 9.0/16.0).isActive = true
        
        addressLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        phoneTextView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20).isActive = true
        phoneTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        phoneTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        phoneTextView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        hoursLabel.topAnchor.constraint(equalTo: phoneTextView.bottomAnchor, constant: 20).isActive = true
        hoursLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        hoursLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        hoursLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    private func setupUI() {
        guard let library = library else {
            return
        }
        title = library.name
        mapView.annotateMap(library: library)
        addressLabel.text = library.address
        phoneTextView.parsePhoneNumber(library: library, controller: self)
        hoursLabel.text = library.hoursOfOperation?.formattedHours
    }
}
