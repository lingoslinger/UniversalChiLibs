//
//  LilbraryViewController.swift
//  SwiftLibrariesNoSB
//
//  Created by Allan Evans on 9/21/21.
//

import UIKit

class LibraryViewController: UIViewController {
    let libraryTableView = UITableView()
    let libraryDataSource = LibraryDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryTableView.dataSource = libraryDataSource
        libraryTableView.delegate = self
        libraryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "LibraryTableViewCell")
        view.addSubview(libraryTableView)
        libraryTableView.translatesAutoresizingMaskIntoConstraints = false
        setupAutoLayout()
        setupNavigation()

        libraryDataSource.getLibraryData { error in
            if error != nil {
                self.showErrorDialogWithMessage(message: error?.localizedDescription ?? "Unknown network error")
            } else {
                self.libraryTableView.reloadData()
            }
        }
    }

    private func setupAutoLayout() {
        libraryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        libraryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        libraryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        libraryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupNavigation() {
        navigationItem.title = "Chicago Libraries"
        navigationController?.navigationBar.isTranslucent = false
    }
}

extension LibraryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let library = libraryDataSource.currentLibrary(indexPath) else { return }
        let detail = LibraryDetailViewController(library: library)
        navigationItem.backButtonTitle = "Libraries"
        navigationController?.pushViewController(detail, animated: true)
    }
}
