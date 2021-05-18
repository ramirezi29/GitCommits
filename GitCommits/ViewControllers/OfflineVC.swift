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
    //Needed in order to keep device's dark mode settings from being active
    override func viewDidLoad() {
        super.viewDidLoad()
        loadText()
    }
    
    func loadText() {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            offlineDetailLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
            offlineTitleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        } else {
            offlineDetailLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            offlineTitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        }
    }
}
