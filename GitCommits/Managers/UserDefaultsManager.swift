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
     Provides the value stored in UserDefaults key Constants isOnboardedKey
     
     ## Important Note ##
     This returns a bool
     */
    func boolValue(for key: String) -> Bool {
        UserDefaults.standard.bool(forKey: key)
    }
    
    /**
     A function that accepts a bool value to change the UserDefaults bool for key value isOnboardedKey
     
     ## Note ##
     At the time of writing this app it is only being used to to set the isOnboardedKey to true. The function was made to accept a either bool value in order for testing purposes and in order to preform future complex logic if  needed.
     */
    func setOnboardBool(to : Bool, for key: String) {
        UserDefaults.standard.set(to, forKey: key)
    }
}
