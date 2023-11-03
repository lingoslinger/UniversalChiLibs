//
//  LibraryLabel.swift
//  SwiftLibrariesNoSB
//
//  Created by Allan Evans on 10/5/21.
//

import UIKit

class LibraryLabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
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
