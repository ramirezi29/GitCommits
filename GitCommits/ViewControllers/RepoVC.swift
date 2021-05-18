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
        naviContStyling() 
        updateBio()
        avatarImageStyling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        
        //NOTE: - fetchAvatar function added in cell for row at in order to combat race conditions where the repo value is nill
        fetchAvatar()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.tintColor = #colorLiteral(red: 0.4148489237, green: 0.4674612284, blue: 0.7991535068, alpha: 1) 
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.RepositoriesText
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
    
    func resetBioDetails() {
        nameLabel.text = "Name \(Constants.unkownText)"
        locationLabel.text = "Location \(Constants.unkownText)"
        followingLabel.text = Constants.unkownText
        followersLabel.text = Constants.unkownText
    }
    
    func avatarImageStyling() {
        avatarImage.layer.borderWidth = 1
        avatarImage.layer.masksToBounds = false
        avatarImage.layer.cornerRadius = avatarImage.frame.height/2
        avatarImage.clipsToBounds = true
    }
    
    func naviContStyling() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func fetchRepos(name: String) {
        NetworkManager.shared.fetchRepos(for: name) { [weak self]   result in
            switch(result) {
            case .failure(let error):
                DispatchQueue.main.async {
                    let error =   AlertManager.presentAlertControllerWith(alertTitle: "", alertMessage: error.rawValue, dismissActionTitle: "OK")
                    self?.present(error, animated: true, completion: nil)
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
                    self?.resetBioDetails()
                }
            case .success(let user):
                self?.user = user
                DispatchQueue.main.async {
                    self?.updateBio()
                }
            }
        }
    }
    
    //NOTE - We're displaying the avator image associated with the first repository in a user's account
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
    
    /**
     Function associated with the search GitHub name textfield. Purpose is to let the program know if the textfield has an entry or not.
     
     */
    @objc private func textFieldDidChange(_ field: UITextField) {
        guard let searchAction = searchAction else { return }
        searchAction.isEnabled = field.text?.count ?? 0 > 0
    }
    
    /**
     Function presents an alert that prompts the user for a GitHub user's account name. If successful a users repositories and user details are fetched through specific functions also included in this function.
     
     */
    @IBAction func searchButtonTapped(_ sender: Any) {
        let alertcontroller = UIAlertController(title: "User Search", message: "", preferredStyle: .alert)
        
        alertcontroller.addTextField { textField in
            textField.placeholder = "Enter GitHub User Name"
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

