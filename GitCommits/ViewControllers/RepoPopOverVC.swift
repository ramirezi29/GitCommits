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
            self.updateView()
        }
        // Do any additional setup after loading the view.
    }
    
    func updateView() {
        guard let repoCommit = repoCommit else { return }
        authorLabel.text = repoCommit.commit.author.name
        hashLabel.text = repoCommit.sha
        messageLabel.text = repoCommit.commit.message
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
