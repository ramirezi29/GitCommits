//
//  User.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/15/21.
//

import Foundation

struct Repo: Decodable {
    let name: String
    let owner: Owner
}

struct Owner: Decodable {
    let avatarURL: URL?
    let login: String
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case login 
    }
}


