//
//  Commit.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/16/21.
//

import UIKit

struct RepoCommit: Decodable {
    let commit: Commit
    let sha: String
}

struct Commit: Decodable {
    let message: String?
    let author: Author
}

struct Author: Decodable {
    let name: String
    let date: String
}

