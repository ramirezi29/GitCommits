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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    var repos: [Repo] = []
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        fetchRepos()
        fetchUser()
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
    
    func fetchRepos() {
        NetworkManager.shared.fetchRepos(for: "ramirezi29") { result in
            switch(result) {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let repos):
                self.repos = repos
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchUser() {
        NetworkManager.shared.fetchDetails(of: "ramirezi29") { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                self.user = user
                
                DispatchQueue.main.async {
                    self.nameLabel.text = user.name
                    self.locationLabel.text = user.location
                    self.followingLabel.text = "\(user.following)"
                    self.followersLabel.text = "\(user.followers)"
                }
            }
        }
    }
}
