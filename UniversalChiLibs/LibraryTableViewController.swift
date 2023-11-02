//
//  LibraryTableViewController.swift
//  UniversalChiLibs
//
//  Created by Allan Evans on 11/2/23.
//

import UIKit
import Foundation

class LibraryTableViewController: UITableViewController {
    
    var libraryArray = [Library]()
    var sectionDictionary = Dictionary<String, [Library]>()
    var sectionTitles = [String]()
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let completionHander : SessionCompletionHandler = {(data : Data?, response : URLResponse?, error : Error?) -> Void in
            if (error == nil) {
                let decoder = JSONDecoder()
                guard let libraryArray = try? decoder.decode([Library].self, from: data!) else {
                    fatalError("Unable to decode JSON library data")
                }
                self.libraryArray = libraryArray
                DispatchQueue.main.async(execute: {
                    self.setupSectionsWithLibraryArray()
                    self.tableView.reloadData()
                })
            } else {
                DispatchQueue.main.async {
                    self.showErrorDialogWithMessage(message: error?.localizedDescription ?? "Unknown network error")
                }
            }
        }
        LibraryURLSession().sendRequest(completionHander)
    }

    // MARK: - UITableViewDataSource and UITableViewDelegate methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = self.sectionTitles[section]
        let sectionArray = self.sectionDictionary[sectionTitle]
        return sectionArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryTableViewCell")
        let sectionTitle = self.sectionTitles[indexPath.section]
        let sectionArray = self.sectionDictionary[sectionTitle]
        let library = sectionArray?[indexPath.row]
        cell?.textLabel?.text = library?.name
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionTitles
    }
    
    // MARK: - navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LibraryDetailViewController" {
            guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
            let detailViewController = segue.destination as! LibraryDetailViewController
            let sectionTitle = self.sectionTitles[indexPath.section]
            let sectionArray = self.sectionDictionary[sectionTitle]
            detailViewController.detailLibrary = sectionArray?[indexPath.row]
        }
    }
    
    // MARK: - private methods
    func setupSectionsWithLibraryArray() {
        for library in libraryArray {
            let firstLetterOfName = String.init(library.name?.first ?? Character.init(""))
            if (sectionDictionary[firstLetterOfName] == nil) {
                let sectionArray = [Library]()
                sectionDictionary[firstLetterOfName] = sectionArray
            }
            sectionDictionary[firstLetterOfName]?.append(library)
        }
        let unsortedLetters = self.sectionDictionary.keys
        sectionTitles = unsortedLetters.sorted()
    }
}
