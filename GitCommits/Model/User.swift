//
//  User.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/16/21.
//

import Foundation

struct User: Decodable {
    let name: String
    let location: String
    let followers: Int
    let following: Int
}
