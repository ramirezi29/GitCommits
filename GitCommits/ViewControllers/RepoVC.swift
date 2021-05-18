//
//  RepoVC.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/16/21.
//

import UIKit

class RepoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    private var searchAction: UIAlertAction?
    
    var repos: [Repo] = []
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
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
        
        fetchAvatar()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Repos"
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
    
    func resetBio() {
        
        nameLabel.text = "Unkown Name"
        locationLabel.text = "Location Unkown"
        followingLabel.text = "Unkown"
        followersLabel.text = "Unkown"
    }
    
    func makeRounded() {
        avatarImage.layer.borderWidth = 1
        avatarImage.layer.masksToBounds = false
        avatarImage.layer.cornerRadius = avatarImage.frame.height/2
        avatarImage.clipsToBounds = true
    }
    
    func fetchRepos(name: String) {
        NetworkManager.shared.fetchRepos(for: name) { [weak self]   result in
            switch(result) {
            case .failure(let error):
                DispatchQueue.main.async {
                    let error =   AlertManager.presentAlertControllerWith(alertTitle: "", alertMessage: error.rawValue, dismissActionTitle: "OK")
                    self?.present(error, animated: true, completion: nil)
                    //                self?.avatarImage.image = UIImage(named: "gitHub")
                }
                return
            case .success(let repos):
                self?.repos = repos
                DispatchQueue.main.async { [self] in
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func fetchUser(name: String) {
        NetworkManager.shared.fetchDetails(of: name) { [weak self] result in
            switch result {
            case .failure(_):
                DispatchQueue.main.async {
                    self?.resetBio()
                }
            case .success(let user):
                self?.user = user
                DispatchQueue.main.async {
                    self?.updateBio()
                }
            }
        }
    }
    
    func fetchAvatar() {
        NetworkManager.shared.fetchAvatar(from: repos[0]) { [weak self] result in
            switch(result) {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let repo):
                DispatchQueue.main.async {
                    self?.avatarImage.image = repo
                }
            }
        }
    }
    
    
    @objc private func textFieldDidChange(_ field: UITextField) {
        guard let searchAction = searchAction else { return }
        searchAction.isEnabled = field.text?.count ?? 0 > 0
    }
    
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        
        let alertcontroller = UIAlertController(title: "Search for user", message: "Enter Name Below", preferredStyle: .alert)
        
        alertcontroller.addTextField { textField in
            textField.placeholder = "Enter GitHub User Name"
            //            nameTextfield = textField
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        
        let textField = alertcontroller.textFields?[0]
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        searchAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            if let name = textField?.text, !name.isEmpty {
                self.fetchRepos(name: name)
                self.fetchUser(name: name)
            }
        }
        
        searchAction?.isEnabled = false
        
        [dismissAction, searchAction ?? UIAlertAction()].forEach { alertcontroller.addAction($0) }
        
        self.present(alertcontroller, animated: true, completion: nil)
    }
}

