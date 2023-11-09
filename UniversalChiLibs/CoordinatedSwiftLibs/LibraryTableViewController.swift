//
//  LibraryTableViewController.swift
//  UniversalChiLibs
//
//  Created by Allan Evans on 11/9/23.
//  Copyright © 2023 AGE Software Consulting, LLC. All rights reserved.
//

import UIKit
import Foundation

class LibraryTableViewController: UITableViewController, Storyboarded {
    
    var libraryArray = [Library]()
    var sectionDictionary = Dictionary<String, [Library]>()
    var sectionTitles = [String]()
    
    let libraryDataSource = LibraryDataSource()
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = libraryDataSource
        tableView.delegate = self
        
        libraryDataSource.getLibraryData { error in
            if error != nil {
                self.showErrorDialogWithMessage(message: error?.localizedDescription ?? "Unknown network error")
            } else {
                self.tableView.reloadData()
            }
        }
    }
}

extension LibraryTableViewController {
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LibraryDetailViewController" {
            guard let indexPath = self.tableView.indexPathForSelectedRow,
                  let library = libraryDataSource.currentLibrary(indexPath) else { return }
            let detailViewController = segue.destination as! LibraryDetailViewController
            detailViewController.detailLibrary = library
        }
    }
}
