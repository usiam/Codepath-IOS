//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Tahamid on 3/18/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    
    var profileInfo: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfile()
        // Do any additional setup after loading the view.
    }
    
    
//success: { (tweets:[NSDictionary]) in
//    self.tweetsArray.removeAll()
//    for tweet in tweets {
//        self.tweetsArray.append(tweet)
//    }
//    self.tableView.reloadData()
//    self.myRefreshControl.endRefreshing()
//}, failure: { (Error) in
//    print("Could not retrieve tweets.")
//})
    
    func loadProfile(){
        let URL = "https://api.twitter.com/1.1/account/verify_credentials.json"
        let parameters = ["include_email": true]
        
        TwitterAPICaller.client?.getDictionaryRequest(url: URL, parameters: parameters, success: {(info: NSDictionary) in
    
            self.userNameLabel.text = info["name"] as? String
            self.taglineLabel.text = info["description"] as? String
            
            let tweetsCount = info["statuses_count"] as! Int
            self.numTweetsLabel.text = "Tweets: \(tweetsCount)"
            
            let numFollowers = info["followers_count"] as! Int
            self.numFollowersLabel.text = "Followers: \(numFollowers)"
            
            let imageURL = Foundation.URL(string: (info["profile_image_url_https"] as? String)!)

            let data = try? Data(contentsOf: imageURL!)

            if let imageData = data {
                self.profileImageView.image = UIImage(data: imageData)
            }
        }, failure: { (Error) in
            print("Could not retrieve profile info.")
        })
        print("HERE")
        print(profileInfo)
    }

    @IBAction func onHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
