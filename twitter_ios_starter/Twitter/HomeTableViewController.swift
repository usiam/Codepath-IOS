//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Tahamid on 3/6/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetsArray = [NSDictionary]()
    var numOfTweets: Int!
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        // self because we want things to happen in this exact view controller
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    @objc func loadTweets(){
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numOfTweets = 10
        let myParams = ["count": numOfTweets!]
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { (tweets:[NSDictionary]) in
            self.tweetsArray.removeAll()
            for tweet in tweets {
                self.tweetsArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not retrieve tweets.")
        })
    }
    
    func loadMoreTweets(){
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numOfTweets = numOfTweets + 5
        let myParams = ["count": numOfTweets!]

        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { (tweets:[NSDictionary]) in
            self.tweetsArray.removeAll()
            for tweet in tweets {
                self.tweetsArray.append(tweet)
            }
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets.")
        })
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // if you are at the end of the count
        if indexPath.row + 1 == tweetsArray.count {
            loadMoreTweets()
        }
    }


    @IBAction func onLogout(_ sender: Any) {
        
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let user = tweetsArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
        
        
        cell.tweetContentLabel.text = tweetsArray[indexPath.row]["text"] as? String
        
        // this is a standard way of setting images
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorite(tweetsArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetID = tweetsArray[indexPath.row]["id"] as! Int
        
        
        cell.setRetweeted(tweetsArray[indexPath.row]["retweeted"] as! Bool) 
        
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetsArray.count
    }

}
