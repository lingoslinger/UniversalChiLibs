//
//  LibraryImageViewController.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 4/15/24.
//  Copyright © 2024 AGE Software Consulting, LLC. All rights reserved.
//

import UIKit
import SwiftUI

class LibraryImageViewController: UIHostingController<LibraryImageView> {
     
    required init?(coder aDecoder: NSCoder) {
        super.init(
            coder: aDecoder, rootView: LibraryImageView(library: nil))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.invalidateIntrinsicContentSize()
    }
}
