//
//  AlertHelper.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/27/23.
//

import UIKit

class AlertHelper {
    static func showAlertWithYesNoOptions(title: String?, message: String?, over viewController: UIViewController, yesHandler: (() -> Void)?, noHandler: (() -> Void)?) {
        
        assert((title ?? message) != nil, "Title OR message must be passed in")

        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            yesHandler?()
        }
        ac.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "No", style: .default) { _ in
            noHandler?()
        }
        ac.addAction(noAction)
        
        viewController.present(ac, animated: true)
    }
}
