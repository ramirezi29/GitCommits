//
//  welcomVC.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/17/21.
//

import UIKit

class WelcomVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var repos: [Repo] = []
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = "ramirezi29"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(WelcomVC.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
        nameTextField.delegate = self
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Constants.toRepoVC {
            
            if nameTextField.text == nil || nameTextField.text == "" {
                let nameError = AlertManager.presentAlertControllerWith(alertTitle:"Invalid Username" , alertMessage: "Username can not be empty, please enter a valid username and try again", dismissActionTitle: "OK")
                DispatchQueue.main.async {
                    self.present(nameError, animated: true, completion: nil)
                }
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.toRepoVC {
            guard let destinationVC = segue.destination as? RepoVC else {
                return
            }
            let name = nameTextField.text
            destinationVC.name = name
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        guard let userName = nameTextField.text, !userName.isEmpty else {
            let textFieldError = AlertManager.presentAlertControllerWith(alertTitle: "Error", alertMessage: "Pleae enter a valid user name and try again, thank you.", dismissActionTitle: "OK")
            
            DispatchQueue.main.async {
                self.present(textFieldError, animated: true, completion: nil)
            }
            return
        }
    }
}
