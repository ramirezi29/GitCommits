//
//  RepoDetailTVC.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/16/21.
//

import UIKit

class RepoDetailTVC: UITableViewController {
    
    var repo: Repo?
    var commits: [RepoCommit] = []
    private let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRepos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let textAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.4148489237, green: 0.4674612284, blue: 0.7991535068, alpha: 1)]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.detailRepoCell, for: indexPath)
        let index = commits[indexPath.row]
        cell.textLabel?.text = index.commit.author.date.readableDate
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.toRepoInfo {
            guard let destinationVC = segue.destination as? RepoPopOverVC, let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            let commit = commits[indexPath.row]
            destinationVC.repoCommit = commit
        }
    }
    
    //NOTE: - Future version would include more robust error handling to properly handling when the fetch repo call fails
    func fetchRepos() {
        guard let repo = repo else { return }
        
        networkManager.getRepoDetails(for: repo.owner.login, repoName: repo.name) { result in
            switch result {
            case (.failure(_)):
                return
            case (.success(let commits)):
                self.commits = commits
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        DispatchQueue.main.async {
            self.title = repo.name
        }
    }
}
