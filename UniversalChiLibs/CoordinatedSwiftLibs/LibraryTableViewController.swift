//
//  LibraryTableViewController.swift
//  UniversalChiLibs
//
//  Created by Allan Evans on 11/9/23.
//  Copyright © 2023 AGE Software Consulting, LLC. All rights reserved.
//

import UIKit
import Foundation

protocol LibraryTableViewControllerDelegate: AnyObject {
    func libraryTableViewControllerDidSelectLibrary(_ selectedLibrary: Library)
}

class LibraryTableViewController: UITableViewController, Storyboarded {
    weak var delegate: LibraryTableViewControllerDelegate?
    
    let libraryDataSource = LibraryDataSource()
    
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let indexPath = self.tableView.indexPathForSelectedRow,
              let library = libraryDataSource.currentLibrary(indexPath) else { return }
        delegate?.libraryTableViewControllerDidSelectLibrary(library)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
