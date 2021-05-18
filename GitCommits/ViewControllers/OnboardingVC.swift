//
//  OnboardingVC.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/18/21.
//

import UIKit

class OnboardingVC: UIViewController {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var detailTextLabel: UILabel!
    @IBOutlet weak var onboardingButton: IRButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpText()
        shouldPresentMVChecker()
    }
    
    // NOTE: - setOnBoardBool is set to true in here as well in order to ensure the bool is toggled to true after the user has seen the onboarding screen.
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaultManager.shared.setOnboardBool(to: true, for: Constants.isOnboardedKey)
    }
    
    func setUpText() {
        titleTextLabel.text = "Git Commits"
        detailTextLabel.text = "Ivan Ramirez"
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            detailTextLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
            titleTextLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        } else {
            detailTextLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            titleTextLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        }
    }
    
    // MARK: - Storyboard Logic
    
    /**
     Function that triggers the root view controller to bet set to the Main storyboard.
    ## Important Note ##
    It's presented in full screen modal presentation in order to avoid the user being able to dissmiss the Main storybaord screen and go back to the onboarding screen.
    */
   func presentMainView() {
       guard let homeStoryboard = UIStoryboard(name: Constants.mainSBTitle, bundle: nil).instantiateInitialViewController()
           else {
               return
       }
       homeStoryboard.modalPresentationStyle = .fullScreen
       UIApplication.shared.keyWindow?.rootViewController = homeStoryboard
       present(homeStoryboard, animated: true, completion: nil)
   }
    
    /**
     IBaction that serves two purposes. When tapped the OneSignal permission prompt is shown. Also, isOnboardedKey bool is set to true.
     
     ## Important Note ##
     The bool is saved to UserDefaults and wont be changed to false until the app is removed from the device. This prevents the onboarding screen form being presented to the user.
     */
    func shouldPresentMVChecker() {
        if UserDefaultManager.shared.boolValue(for: Constants.isOnboardedKey) {
            presentMainView()
        }
    }
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        guard segue.identifier == Constants.segueToMain else {  return }

        presentMainView()
        
    }
    
    @IBAction func onboardButtonTapped(_ sender: Any) {
        HapticController.createFeedBack()
        UserDefaults.standard.set(true, forKey: Constants.isOnboardedKey)
    }
    
}
