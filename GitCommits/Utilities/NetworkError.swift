//
//  NetworkError.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/15/21.
//

import Foundation

enum NetworkingError: Error {
    
    case badBaseURL(String)
    case forwardedError(Error)
    case invalidData(String)
    case badBuiltURL(String)
    case invalidResponse(String)
}
