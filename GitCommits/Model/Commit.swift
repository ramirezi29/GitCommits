//
//  Commit.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/16/21.
//

import UIKit

//struct TopLevelDictionary: Decodable {
//    let commit: Commit
//}

struct RepoCommit: Decodable {
    let commit: Commit
    
}

struct Commit: Decodable {
    let message: String?
    let author: Author
}

struct Author: Decodable {
    let name: String
    let date: String
    
    
    }

