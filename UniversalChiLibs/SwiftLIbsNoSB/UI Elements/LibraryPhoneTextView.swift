//
//  LibraryPhoneTextView.swift
//  SwiftLibrariesNoSB
//
//  Created by Allan Evans on 10/5/21.
//

import UIKit

class LibraryPhoneTextView: UITextView {
    @available(*, unavailable,
                message: "LibraryMapView is not designed to be initialized from a storyboard."
    )
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.commonInit()
    }
    
    private func commonInit() {
        textColor = .link
        font = UIFont.systemFont(ofSize: 17)
        textAlignment = .natural
        dataDetectorTypes = [.phoneNumber]
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func parsePhoneNumber(library: Library, controller: UIViewController) {
        guard let phone = library.phone else { return }
        var numberOfMatches = 0
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            numberOfMatches = detector.numberOfMatches(in: phone, range: NSRange(phone.startIndex..., in: phone))
        } catch {
            controller.showErrorDialogWithMessage(message: error.localizedDescription)
        }
        // update: a new construction message appears in the hours field. Leaving this here just in case (for now anyway.)
        if numberOfMatches == 0 { // if no phnone number here, a "closed for construction" message is the only other result, so...
            textColor = #colorLiteral(red: 0.9952842593, green: 0.1894924343, blue: 0.3810988665, alpha: 1)
            text = phone
        } else {
            text = "Phone: \(phone)"
        }
    }
}
