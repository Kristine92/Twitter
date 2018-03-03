//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var repliesLabel: UILabel!
    @IBOutlet weak var retweetsButton: UIButton!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var tweet: Tweet! {
        didSet {
            if (tweet.favorited)! {
                favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: UIControlState.normal)
            } else {
                favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: UIControlState.normal)
            }
            tweetTextLabel.text = tweet.text
            authorLabel.text = tweet.user.name
            screenNameLabel.text = "@" + tweet.user.screenName!
            dateLabel.text = tweet.createdAtString
            let retweetCountString = String(tweet.retweetCount)
            retweetsLabel.text = retweetCountString
            let favoriteCountString = String(describing: tweet.favoriteCount)
            favoriteLabel.text = favoriteCountString
            let profileUrl = URL(string: tweet.user.profileImageUrl!)!
            profileImageView.af_setImage(withURL: profileUrl)
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
    
    @IBAction func didTapFavorite(_ sender: Any) {
        if(tweet.favorited == false) {
            tweet.favorited = true
            tweet.favoriteCount += 1
            let favorite = 1
            refreshData(value: favorite)
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            }
        } else {
            tweet.favorited = false
            tweet.favoriteCount -= 1
            let unfavorite = 2
            refreshData(value: unfavorite)
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                }
            }
        }
    }
    
    func refreshData(value: Int) {
        switch value {
        case 1:
            let favoriteCountString = String(describing: tweet.favoriteCount)
            favoriteLabel.text = favoriteCountString
            favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: UIControlState.normal)
        case 2:
            let favoriteCountString = String(describing: tweet.favoriteCount)
            favoriteLabel.text = favoriteCountString
            favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: UIControlState.normal)
        case 3:
            let retweetCountString = String(tweet.retweetCount)
            retweetsLabel.text = retweetCountString
            retweetsButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: UIControlState.normal)
        case 4:
            let retweetCountString = String(tweet.retweetCount)
            retweetsLabel.text = retweetCountString
            retweetsButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: UIControlState.normal)
        default:
            print("Invalid case")
        }
    }
    
    @IBAction func didTapRetweet(_ sender: Any) {
        if (tweet.retweeted == false) {
            tweet.retweeted = true
            tweet.retweetCount += 1
            let retweet = 3
            refreshData(value: retweet)
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                }
            }
        } else {
            tweet.retweeted = false
            tweet.retweetCount -= 1
            let retweet = 4
            refreshData(value: retweet)
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unretweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
                }
            }
        }
    }
}
