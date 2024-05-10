//
//  LibraryLabel.swift
//  SwiftLibrariesNoSB
//
//  Created by Allan Evans on 10/5/21.
//

import UIKit

class LibraryLabel: UILabel {
    @available(*, unavailable,
                message: "LibraryMapView is not designed to be initialized from a storyboard."
    )
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    convenience init(numberOfLines: Int) {
        self.init()
        self.numberOfLines = numberOfLines
    }
    
    private func commonInit() {
        font = UIFont.systemFont(ofSize: 17)
        textAlignment = .natural
        translatesAutoresizingMaskIntoConstraints = false
    }
}
