//
//  HapticController.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/18/21.
//

import UIKit

class HapticController {
    
    static var selection: UISelectionFeedbackGenerator?
    
    /**
     Creates a selected change style haptic feedback response
     
     */
    static func createFeedBack() {
        selection = UISelectionFeedbackGenerator()
        selection?.prepare()
        selection?.selectionChanged()
    }
}
