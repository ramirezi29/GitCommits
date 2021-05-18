//
//  RepoPopOverVC.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/16/21.
//

import UIKit

class RepoPopOverVC: UIViewController {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var hashLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
      
    var repoCommit: RepoCommit?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.updateTextFields()
        }
    }
    
    /**
     Function updates the text labels associated with the user's GitHub detials
     
     */
    func updateTextFields() {
        guard let repoCommit = repoCommit else { return }
        authorLabel.text = repoCommit.commit.author.name
        hashLabel.text = repoCommit.sha
        messageLabel.text = repoCommit.commit.message
    }
}
