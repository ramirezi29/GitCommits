//
//  IRButton.swift
//  GitCommits
//
//  Created by Ivan Ramirez on 5/18/21.
//

import UIKit

class IRButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    /**
     Styles a button with a specific set of options
     
     */
    private func setupButton() {
        setTitleColor(.white, for: .normal)
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 9.0
        layer.masksToBounds = false
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        layer.cornerRadius = frame.size.height / 5
    }
}
