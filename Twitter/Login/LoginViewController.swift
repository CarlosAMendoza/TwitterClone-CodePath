//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by Carlos Mendoza on 11/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1).cgColor
        button.layer.cornerRadius = 8
        button.sizeToFit()
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    let logo: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.image = UIImage(named: "TwitterLogoBlue")
        logo.contentMode = .scaleAspectFit
        return logo
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(button)
        view.addSubview(logo)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logo.bottomAnchor.constraint(equalTo: button.topAnchor, constant: 20),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
    }
    
    @objc private func login() {
        let base = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: base, success: {
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            self.view.window?.rootViewController = UINavigationController(rootViewController: HomeTableViewController())
            
        }, failure: { (error) in
            print("Error")
        })
    }
    

}
