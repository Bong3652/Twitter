//
//  DetailViewController.swift
//  Twitter
//
//  Created by APPLE on 2/6/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetsTableView: UITableView!
    
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    var tweetAndReplies = [NSDictionary]()
    //let userId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 10
        profileImage.layer.borderColor = #colorLiteral(red: 0.3608938848, green: 0.8235047383, blue: 1, alpha: 1)
        // Do any additional setup after loading the view.
        setUpProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //setUpProfile()
    }
    
    func setUpProfile() {
        let url = "https://api.twitter.com/1.1/users/search.json"
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: ["q" : "Bong3652"], success: { (profileSize: [NSDictionary]) in
            print(profileSize)
            let me = profileSize[0]
            
            self.tweetsLabel.text = "Tweets: \(me["statuses_count"] as! Int)"
            self.followingLabel.text = "Following: \(me["friends_count"] as! Int)"
            self.likesLabel.text = "Likes: \(me["favourites_count"] as! Int)"
            let urlImage = URL(string: me["profile_image_url_https"] as! String)
            let data = try? Data(contentsOf: urlImage!)
            
            if let imageData = data {
                self.profileImage.image = UIImage(data: imageData)
            }
            
            //self.loadTweetsandReplies()
            print("count tweetAndReplies \(self.tweetAndReplies.count)")
            
        }, failure: { (Error) in
            print("could not retreive tweets")
        })
    }
    
    func loadTweetsandReplies() {
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        let param = ["count":40]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: param, success: { (tweets: [NSDictionary]) in
            self.tweetAndReplies.removeAll()
            
            for tweet in tweets {
                self.tweetAndReplies.append(tweet)
                print(tweet)
            }
            self.tweetsTableView.reloadData()
        }, failure: { (Error) in
            print("could not retreive tweets")
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetAndReplies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "TweetsAndRepliesCell", for: indexPath) as! TweetCell
        let tweet = tweetAndReplies[indexPath.row]
        let user = tweet["user"] as! NSDictionary
        
        cell.profileNameLabel.text = user["name"] as! String
        cell.tweetContentLabel.text = tweet["text"] as! String
        
        let urlImage = URL(string: user["profile_image_url_https"] as! String)
        let data = try? Data(contentsOf: urlImage!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        cell.setFavorited(tweet["favorited"] as! Bool)
        cell.tweetId = tweet["id"] as! Int
        cell.setRetweeted(tweet["retweeted"] as! Bool)
        return cell
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
