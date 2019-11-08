//
//  ComposeViewController.swift
//  TwitterClone
//
//  Created by Carlos Mendoza on 11/8/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    let text: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
//        text.layer.borderColor = UIColor.black.cgColor
//        text.layer.borderWidth = 1
//        text.layer.cornerRadius = 5
        text.font = UIFont.preferredFont(forTextStyle: .body)
        return text
    }()
    
    let tweetButton: UIBarButtonItem = {
        let tweet = UIBarButtonItem()
        tweet.title = "Tweet"
        return tweet
    }()
    
    let cancelButton: UIBarButtonItem = {
        let cancel = UIBarButtonItem()
        cancel.title = "Cancel"
        return cancel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = cancelButton
        cancelButton.target = self
        cancelButton.action = #selector(cancel)
        navigationItem.rightBarButtonItem = tweetButton
        tweetButton.target = self
        tweetButton.action = #selector(tweet)
        
        
        
        self.title = "Compose"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 132/255, blue: 180/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        view.addSubview(text)
        
        NSLayoutConstraint.activate([
            text.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            text.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            text.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            text.heightAnchor.constraint(equalToConstant: 400)
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        text.becomeFirstResponder()
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func tweet() {
        if (!text.text.isEmpty && text.text.utf8.count <= 280) {
            TwitterAPICaller.client?.postTweet(tweetString: text.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print(error)
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            print("Too Many Characters")
            print("Count: \(text.text.utf8.count)")
        }
    }

}
