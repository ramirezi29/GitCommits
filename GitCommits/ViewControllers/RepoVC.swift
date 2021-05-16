//
//  RepoVC.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/16/21.
//

import UIKit

class RepoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImage: UIImageView!
    
    var repos: [Repo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        avatarImage.image = UIImage(named: "github")
        
        NetworkManager.shared.fetchRepos(for: "ramirezi29") { result in
            switch(result) {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let repos):
                self.repos = repos
                print(repos.count)
                
           
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: Constants.repoCell, for: indexPath)
        
        
        let repo = repos[indexPath.row]
        
        cell.textLabel?.text = repo.name
        
        NetworkManager.shared.fetchAvatar(from: repos[0]) { result in
            switch(result) {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let repo):
                
                DispatchQueue.main.async {
                    
                    self.avatarImage.image = repo
                }
            }
        }
        return cell
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
