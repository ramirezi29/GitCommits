//
//  OfflineVC.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/18/21.
//

import UIKit

class OffLineVC: UIViewController {
    
    @IBOutlet weak var offlineDetailLabel: UILabel!
    @IBOutlet weak var offlineTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleLabels()
    }
    
    /**
     Function styles the text according if the user's device is an iPad or iPhone
     
     */
    func styleLabels() {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            offlineDetailLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
            offlineTitleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        } else {
            offlineDetailLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            offlineTitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        }
    }
}
