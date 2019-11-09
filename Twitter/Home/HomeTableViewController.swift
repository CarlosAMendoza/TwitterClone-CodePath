//
//  HomeTableViewController.swift
//  TwitterClone
//
//  Created by Carlos Mendoza on 11/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController, UIAdaptivePresentationControllerDelegate{
    
    let tweetCellIndentifier = "TweetCell"
    
    var tweet = [NSDictionary]()
    
    let logoutButton: UIBarButtonItem = {
        let logoutButton = UIBarButtonItem()
        logoutButton.title = "Logout"
        return logoutButton
    }()
    
    let tweetButton: UIBarButtonItem = {
        let tweetButton = UIBarButtonItem()
        tweetButton.title = "Tweet"
        return tweetButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        
        self.title = "Home"
        self.navigationItem.leftBarButtonItem = logoutButton
        logoutButton.action = #selector(logout)
        logoutButton.target = self
        
        self.navigationItem.rightBarButtonItem = tweetButton
        tweetButton.action = #selector(compose)
        tweetButton.target = self
        
        
//        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0, green: 132/255, blue: 180/255, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 132/255, blue: 180/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        tableView.register(TweetCell.self, forCellReuseIdentifier: tweetCellIndentifier)
        tableView.rowHeight = UITableView.automaticDimension
        
        loadTweet()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadTweet(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": 20]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets) in
            self.tweet.removeAll()
            for tweet in tweets {
                self.tweet.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (error) in
            print("Error")
        })
        
        
    }
    
    // MARK: - BarButton Functions
    
    @objc private func compose() {
        let composeViewController = UINavigationController(rootViewController: ComposeViewController())
        composeViewController.presentationController?.delegate = self
        present(composeViewController, animated: true, completion: nil)
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        loadTweet()
    }
    
    @objc private func logout() {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        if let window = self.view.window {
            window.rootViewController = LoginViewController()
            window.makeKeyAndVisible()
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweet.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tweetCellIndentifier, for: indexPath) as! TweetCell
        
        let user = tweet[indexPath.row]["user"] as! NSDictionary
        cell.author.text = user["name"] as? String
        cell.tweetText.text = tweet[indexPath.row]["text"] as? String
        
        let imgUrl = URL(string: (user["profile_image_url_https"] as! String).replacingOccurrences(of: "normal", with: "bigger"))
        let data = try? Data(contentsOf: imgUrl!)
        
        if let imageData = data {
            cell.profilePic.image = UIImage(data: imageData)
        }
        
        if let favorited = tweet[indexPath.row]["favorited"] as? Bool {
            cell.favorited = favorited
        }
        
        if let retweeted = tweet[indexPath.row]["retweeted"] as? Bool {
            cell.retweeted = retweeted
        }
        
        cell.favoriteTweetAction = { (cell) in
            let id = self.tweet[indexPath.row]["id"] as! Int
            if cell.favorited {
                TwitterAPICaller.client?.unfavoriteTweet(tweetId: id, success: {
                    cell.favorited = false
                    self.loadTweet()
                }, failure: { (error) in
                    print(error)
                })
            } else {
                TwitterAPICaller.client?.favoriteTweet(tweetId: id, success: {
                    cell.favorited = true
                    self.loadTweet()
                }, failure: { (error) in
                    print(error)
                })
            }
        }
        
        cell.retweetedAction = { (cell) in
            let id = self.tweet[indexPath.row]["id"] as! Int
            if !cell.retweeted {
                TwitterAPICaller.client?.retweet(tweetId: id, success: {
                    cell.retweeted = true
                    self.loadTweet()
                }, failure: { (error) in
                    print(error)
                })
            }
        }
        
    
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class TweetCell: UITableViewCell {
    
    let profilePic: UIImageView = {
        let profilePic = UIImageView()
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        profilePic.contentMode = .scaleAspectFill
        profilePic.clipsToBounds = true
        profilePic.layer.masksToBounds = true
        profilePic.widthAnchor.constraint(equalTo: profilePic.heightAnchor, multiplier: 1).isActive = true
        return profilePic
    }()
    
    let author: UILabel = {
        let author = UILabel()
        author.translatesAutoresizingMaskIntoConstraints = false
        author.font = UIFont.preferredFont(forTextStyle: .headline)
        return author
    }()
    
    let tweetText: UILabel = {
        let tweetText = UILabel()
        tweetText.translatesAutoresizingMaskIntoConstraints = false
        tweetText.font = UIFont.preferredFont(forTextStyle: .body)
        tweetText.numberOfLines = 0
        return tweetText
    }()
    
    let likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
        return likeButton
    }()
    
    let retweetButton: UIButton = {
        let retweetButton = UIButton()
        retweetButton.translatesAutoresizingMaskIntoConstraints = false
        retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
        return retweetButton
    }()
    
    var favoriteTweetAction: ((TweetCell) ->Void)?
    var retweetedAction: ((TweetCell)->Void)?
    
    @objc func invokeFavoriteTweet(_ sender: Any){
        favoriteTweetAction?(self)
    }
    
    @objc func invokeRetweet(_ sender:Any){
        retweetedAction?(self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
        likeButton.addTarget(self, action: #selector(invokeFavoriteTweet), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(invokeRetweet), for: .touchUpInside)
    }
    
    private func setupUI(){
        contentView.addSubview(profilePic)
        contentView.addSubview(author)
        contentView.addSubview(tweetText)
        contentView.addSubview(likeButton)
        contentView.addSubview(retweetButton)
        
        NSLayoutConstraint.activate([
            profilePic.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            profilePic.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            author.topAnchor.constraint(equalTo: profilePic.topAnchor),
            author.leftAnchor.constraint(equalTo: profilePic.rightAnchor, constant: 10),
            author.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            tweetText.topAnchor.constraint(equalTo: author.bottomAnchor, constant: 10),
            tweetText.leftAnchor.constraint(equalTo: profilePic.rightAnchor, constant: 10),
            tweetText.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
//            tweetText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            profilePic.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/8)
        ])
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: tweetText.bottomAnchor),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            likeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            retweetButton.topAnchor.constraint(equalTo: likeButton.topAnchor),
            retweetButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            retweetButton.rightAnchor.constraint(equalTo: likeButton.leftAnchor, constant: -10)
        ])
        
        layoutIfNeeded()
    }
    
    var favorited:Bool = false {
        didSet{
            if favorited {
                likeButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            } else {
                likeButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
            }
        }
    }
    
    var retweeted:Bool = false {
        didSet{
            if retweeted {
                retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
            } else {
                retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePic.layer.cornerRadius = profilePic.frame.size.height/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
