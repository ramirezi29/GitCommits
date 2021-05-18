//
//  Constants.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/16/21.
//

import Foundation

struct Constants {
    
    //GitHub User and Repos
    static let toRepoVC = "toRepoVC"
    static let repoCell = "repoCell"
    static let detailRepo = "toDetailRepoVC"
    static let detailRepoCell = "detailRepoCell"
    static let toRepoInfo = "toRepoInfoVC"
    
    //Main storyboard 
    static let mainSBTitle = "Main"
    static let onlineViewSBKey = "onlineView"
    
    //Ofline storyboard
    static let offLineSBTitle = "Offline"
    static let offlineSBKey = "offlineView"
    
    //Onboarding storyboard
    static let onboardSBTitle = "Onboarding"
    static let segueToMain = "segueToMain"
    
    //Bool
    static let isOnboardedKey = "isOnboardedKey"
    
    //Text
    static let RepositoriesText = "Repositories"
    static let unkownText = "Unknown"
    static let appNameText = "Git Commits"
    static let appDetailText = "Thank you for reviewing my app"
    
    //API Call
    //NOTE: - Be mindful if alterted, these values are used to build the URLs
    static let baseURL = "https://api.github.com"
    static let usersText = "users"
    static let reposText = "repos"
    static let commitsText = "commits"
    static let perPageText = "per_page"
    static let twentyFiveText = "25"
    
}
