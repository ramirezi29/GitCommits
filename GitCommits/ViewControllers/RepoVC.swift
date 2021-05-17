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
    
    
    var name: String?
    
    var repos: [Repo] = []
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        fetchUser(name: name ?? "")
        fetchRepos(name: name ?? "")
        
        navigationController?.navigationBar.isTranslucent = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
          navigationController?.navigationBar.shadowImage = UIImage()
          navigationController?.navigationBar.isTranslucent = true
        updateBio()
        makeRounded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
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
    
    func updateBio() {
        guard let user = user else { return }
        
        nameLabel.text = user.name
        locationLabel.text = user.location
        followingLabel.text = "\(user.following)"
        followersLabel.text = "\(user.followers)"
    }
    
    func makeRounded() {
        avatarImage.layer.borderWidth = 1
        avatarImage.layer.masksToBounds = false
        avatarImage.layer.cornerRadius = avatarImage.frame.height/2
        avatarImage.clipsToBounds = true
    }
    
    func fetchRepos(name: String) {
        NetworkManager.shared.fetchRepos(for: name) { result in
            switch(result) {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let repos):
                self.repos = repos
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func fetchUser(name: String) {
        NetworkManager.shared.fetchDetails(of: name) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                self.user = user
                DispatchQueue.main.async {
                    self.updateBio()
                }
            }
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        fetchRepos(name: name ?? "")
        fetchUser(name: name ?? "")
    }
}
