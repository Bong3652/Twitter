//
//  TweetCell.swift
//  Twitter
//
//  Created by APPLE on 1/29/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var favorited: Bool = false
    var retweeted: Bool = false
    var tweetId: Int = -1
    
    func setFavorited(_ isFavorited: Bool) {
        favorited = isFavorited
        if (favorited) {
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        } else {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted: Bool) {
        retweeted = isRetweeted
        if (retweeted) {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didFav(_ sender: UIButton) {
        if (favorited) {
            TwitterAPICaller.client?.unFavoriteTweet(id: tweetId, success: {
                self.setFavorited(false)
            }, failure: { (error) in
                print("Failed To Favorite")
            })
        } else {
            TwitterAPICaller.client?.favoriteTweet(id: tweetId, success: {
                self.setFavorited(true)
            }, failure: { (error) in
                print("Failed To Favorite")
            })
        }
    }
    
    @IBAction func didRetweet(_ sender: UIButton) {
        TwitterAPICaller.client?.reTweet(id: tweetId, success: {
            self.setRetweeted(true)
        }, failure: { (error) in
            print("Failed Retweet")
        })
    }
}
