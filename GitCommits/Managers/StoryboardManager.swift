//
//  StoryboardManager.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/18/21.
//

import UIKit

struct StroryBoardManager {
    
    static let shared = StroryBoardManager()
    
    /**
     Function decideds to present either main storyboard or off line storyboard depending on the bool value of isOnboardedKey
     
     ## Important Note ##
     The bool's value changes when the onboard storybaord screen either dissapears or the user selctes the segue button that takes the user to the main storyboard view.
     */
    func presentMyStoryboard(window: UIWindow?) {
        guard let window = window else { return }
        if UserDefaults.standard.bool(forKey: Constants.isOnboardedKey) {
            let storyboard = UIStoryboard(name: Constants.mainSBTitle, bundle: nil)
            window.rootViewController = storyboard.instantiateInitialViewController()
        } else {
            let storyboard = UIStoryboard(name: Constants.onboardSBTitle, bundle: nil)
            window.rootViewController = storyboard.instantiateInitialViewController()
        }
        window.makeKeyAndVisible()
    }
    
    /**
     Removes the window's root view controller.
     
     ## Important Note ##
     This is called when removing the offline storyboard view to show the main storyboard view to the user.
     */
    func removeOfflinveView(window: UIWindow?) {
        guard let window = window else { return }
        let rootViewController = window.rootViewController
        rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    /**
     Presents the offline storyboard view to the user.
     
     ## Important Note ##
     The window's root view controller is switched to the offline storyboard
     */
    func instantiateOfflineView(window: UIWindow?) {
        guard let window = window else { return }
        let rootViewController = window.rootViewController
        let offLineSB = UIStoryboard(name: Constants.offLineSBTitle, bundle: nil)
        let offLineVC = offLineSB.instantiateViewController(withIdentifier: Constants.offlineSBKey)
        offLineVC.modalPresentationStyle = .fullScreen
        rootViewController?.present(offLineVC, animated: true, completion: nil)
        window.makeKeyAndVisible()
    }
}

