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
        button.backgroundColor = .blue
        button.sizeToFit()
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    @objc private func login() {
        let base = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: base, success: {
            
            self.view.window?.rootViewController = UINavigationController(rootViewController: HomeTableViewController())
            
        }, failure: { (error) in
            print("Error")
        })
    }
    

}
