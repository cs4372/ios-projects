//
//  AlertHelper.swift
//  Budget-App
//
//  Created by Catherine Shing on 3/15/23.
//

import UIKit

class AlertHelper {
    static func showAlert(title: String?, message: String?, over viewController: UIViewController) {

        assert((title ?? message) != nil, "Title OR message must be passed in")

        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(.gotIt)
        viewController.present(ac, animated: true)
    }
}

extension UIAlertAction {
    static var gotIt: UIAlertAction {
        return UIAlertAction(title: "Got it", style: .default, handler: nil)
    }
}
