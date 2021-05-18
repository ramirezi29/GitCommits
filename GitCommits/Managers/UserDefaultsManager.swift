//
//  UserDefaultsManager.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/18/21.
//

import UIKit

struct UserDefaultManager {
    static let shared = UserDefaultManager()
    
    /**
     Provides the value stored in UserDefaults
     
     ## Note ##
     This returns a bool
     */
    func boolValue(for key: String) -> Bool {
        UserDefaults.standard.bool(forKey: key)
    }
    
    /**
     A function that accepts a bool value to change the UserDefaults bool for key value
     
     ## Important Note ##
     Currently being used to set the bool value to true
     */
    func setOnboardBool(to : Bool, for key: String) {
        UserDefaults.standard.set(to, forKey: key)
    }
}
