//
//  extensions.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/16/21.
//

import UIKit

extension String {
    
    var prettyDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            let foo = dateFormatter.string(from: date)
            return foo
        } else {
            return ""
        }
    }
}
