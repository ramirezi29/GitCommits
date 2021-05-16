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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        makeRounded()
    }
    
    func makeRounded() {

        avatarImage.layer.borderWidth = 1
        avatarImage.layer.masksToBounds = false
        
        avatarImage.layer.cornerRadius = avatarImage.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        avatarImage.clipsToBounds = true
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

    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.detailRepo {
            
            guard let destinationVC = segue.destination as? RepoDetailTVC,
                  let indexPath = tableView.indexPathForSelectedRow else {
                return
            }

            let repo = repos[indexPath.row]
            
            destinationVC.repo = repo
        }
    }
    

}
