//
//  AppDelegate.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/15/21.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var isOffline: Bool = false
    var reachability: Reachability?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.reachability = Reachability()
        
        StroryBoardManager.shared.presentMyStoryboard(window: window)
        
        // From no network to network
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async() {
                self.setOfflineView(false)
            }
        }
        // From network to no network
        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async() {
                self.setOfflineView(true)
            }
        }
        do {
            // On start up this fires to check
            try reachability?.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
        
        
        
        return true
    }
    
    // when disableOnboardingBool is true, then the offline view can be presented. This design pattern is to prevent the offline view from being presented over the initial login screen
    func setOfflineView(_ offline: Bool) {
        switch offline {
        case true:
            if UserDefaultManager.shared.boolValue(for: Constants.isOnboardedKey) {
                StroryBoardManager.shared.instantiateOfflineView(window: window)
            }
        case false:
            StroryBoardManager.shared.removeOfflinveView(window: window)
        }
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        isOffline = self.reachability?.currentReachabilityStatus == Reachability.NetworkStatus.notReachable
        if (isOffline) {
            setOfflineView(isOffline)
        }
    }
}

