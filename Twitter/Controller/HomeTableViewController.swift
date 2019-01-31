//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by APPLE on 1/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweets = [NSDictionary]()
    var numOfTweets: Int!
    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myRefreshControl.addTarget(self
            , action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        loadTweets()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func loadTweets() {
        
        numOfTweets = 20
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        let param = ["count":numOfTweets!]
            
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: param, success: { (tweets: [NSDictionary]) in
            self.tweets.removeAll()
            for tweet in tweets {
                self.tweets.append(tweet)
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }, failure: { (Error) in
            print("could not retreive tweets")
        })
    }
    
    func loadMoreTweets() {
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numOfTweets = numOfTweets + 20
        let param = ["count":numOfTweets!]
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: param, success: { (tweets: [NSDictionary]) in
            self.tweets.removeAll()
            for tweet in tweets {
                self.tweets.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("could not retreive tweets")
        })
    }

    @IBAction func didLogout(_ sender: UIBarButtonItem) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "LoggedIn")
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        // Configure the cell...
        let tweet = tweets[indexPath.row]
        let user = tweet["user"] as! NSDictionary
        
        cell.profileNameLabel.text = user["name"] as! String
        cell.tweetContentLabel.text = tweet["text"] as! String
        
        let urlImage = URL(string: user["profile_image_url_https"] as! String)
        let data = try? Data(contentsOf: urlImage!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        //cell.layer.borderWidth = 10
        //cell.layer.borderColor = #colorLiteral(red: 0.3608938848, green: 0.8235047383, blue: 1, alpha: 1)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweets.count {
            loadMoreTweets()
        }
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
