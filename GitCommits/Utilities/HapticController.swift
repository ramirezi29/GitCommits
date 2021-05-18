//
//  HapticController.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/18/21.
//

import UIKit

class HapticController {
    
    static var selection: UISelectionFeedbackGenerator?
    
    static func createFeedBack() {
        var activateHaptic = true
        switch activateHaptic {
        case true:
            selection = UISelectionFeedbackGenerator()
            selection?.prepare()
            selection?.selectionChanged()
            activateHaptic.toggle()
        case false:
            selection = nil
        }
    }
}
