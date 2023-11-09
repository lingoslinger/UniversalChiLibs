//
//  LibraryTableViewControllerDelegate.swift
//  UniversalChiLibs
//
//  Created by Allan Evans on 11/9/23.
//  Copyright © 2023 AGE Software Consulting, LLC. All rights reserved.
//

import UIKit

protocol LibraryTableViewControllerDelegate: AnyObject {
    func libraryTableViewControllerDidSelectLibrary(_ selectedLibrary: Library)
}
