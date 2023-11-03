//
//  ViewController+ErrorDialog.swift
//  UniversalChiLibs
//
//  Created by Allan Evans on 11/2/23.
//  Copyright © 2023 AGE Software Consulting, LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorDialogWithMessage(message: String) {
        let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.navigationController?.pushViewController(alert, animated: true)
    }
}
