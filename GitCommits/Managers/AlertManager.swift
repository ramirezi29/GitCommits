//
//  AlertManager.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/17/21.
//

import UIKit

class AlertManager {
    
    /**
     Creates a UIAlert and accepts a title, alert message and dismiss title
     
     */
    static func presentAlertControllerWith(alertTitle: String, alertMessage: String?, dismissActionTitle: String) -> UIAlertController {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: dismissActionTitle, style: .cancel, handler: nil)
        alertController.addAction(dismissAction)
        
        return alertController
    }
}
