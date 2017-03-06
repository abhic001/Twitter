//
//  TwitterCell.swift
//  Twitter
//
//  Created by Abhijeet Chakrabarti on 2/27/17.
//  Copyright © 2017 Abhijeet Chakrabarti. All rights reserved.
//

import UIKit

protocol TweetCellDelegate: class  {
    func profileImageViewTapped(cell: TwitterCell, user: User)
}

class TwitterCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    
    weak var delegate: TweetCellDelegate?
    
    var tweet: Tweet! {
        willSet {
            nameLabel.text = newValue.name!
            let profileImgURL = URL(string: newValue.profileImgUrlString!)
            avatarImageView.setImageWith(profileImgURL!)
            screenNameLabel.text = "@\(newValue.screenName!)"
            descriptionLabel.text = newValue.text!
            
            let timeAgo = Int(Date().timeIntervalSince(newValue.timestamp!))
            let ago = convertSecondToDateAgo(seconds: timeAgo)
            timeLabel.text = ago
            
            let favoriteCountString = convertCount(count: newValue.favoritesCount)
            let retweetCountString = convertCount(count: newValue.retweetCount)
            
            retweetCountLabel.text = retweetCountString
            favoriteCountLabel.text = favoriteCountString
            
            if(newValue.favorited)! {
                self.favoriteImageView.image = UIImage(named: "favor-icon-red")
            } else {
                self.favoriteImageView.image = UIImage(named: "favor-icon")
            }
            
            if(newValue.retweeted)! {
                self.retweetImageView.image = UIImage(named: "retweet-icon-green")
            } else {
                self.retweetImageView.image = UIImage(named: "retweet-icon")
            }
        }
        didSet {
            //do nothing
        }
    }
    
    func convertSecondToDateAgo(seconds: Int) -> String {
        var result: String?
        
        if(seconds/60 <= 59) {
            result = "\(seconds/60) m"
        } else if (seconds/3600 <= 23) {
            result = "\(seconds/3600) h"
        } else {
            result = "\(seconds/216000) d"
        }
        return result!
    }
    
    func convertCount(count: Int) -> String {
        var result: String?
        
        if(count/1000 >= 1 && count/1000 <= 100) {
            result = "\(count/1000) k"
        } else if(count/1000000 >= 1) {
            result = "\(count/1000000) m"
        } else {
            result = "\(count)"
        }
        
        return result!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cellTapRecognizerRetweet = UITapGestureRecognizer(target: self, action: #selector(TwitterCell.onTapRetweet(_:)))
        cellTapRecognizerRetweet.cancelsTouchesInView = true
        retweetImageView.addGestureRecognizer(cellTapRecognizerRetweet)
        
        let cellTapRecognizerFavorite = UITapGestureRecognizer(target: self, action: #selector(TwitterCell.onTapFavorite(_:)))
        cellTapRecognizerFavorite.cancelsTouchesInView = true
        favoriteImageView.addGestureRecognizer(cellTapRecognizerFavorite)
        
        let cellTapRecognizerProfile = UITapGestureRecognizer(target: self, action: #selector(TwitterCell.onTapProfile(_:)))
        cellTapRecognizerProfile.cancelsTouchesInView = true
        avatarImageView.addGestureRecognizer(cellTapRecognizerProfile)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func onTapRetweet(_ sender: Any) {
        print("tapped retweet")
        
        TwitterClient.shared?.retweet(id: tweet.id_str!, success: { (response: Tweet) in
            print(response.text!)
            print("retweet begin")
            self.retweetImageView.image = UIImage(named: "retweet-icon-green")
            self.retweetCountLabel.text = self.convertCount(count: response.retweetCount)
            self.tweet.retweetCount = response.retweetCount
            self.tweet.retweeted = true
        }, faliure: { (error: Error) in
            print(error.localizedDescription)
            print("already retweeted")
            TwitterClient.shared?.unretweet(id: self.tweet.id_str!, success: { (response: Tweet) in
                self.retweetImageView.image = UIImage(named: "retweet-icon")
                self.retweetCountLabel.text = self.convertCount(count: response.retweetCount - 1)
                self.tweet.retweetCount = response.retweetCount
                self.tweet.retweeted = false
                print("unretweeted")
            }, faliure: { (error: Error) in
                //nothing
            })
        })
    }
    
    func onTapFavorite(_ sender: Any) {
        
        TwitterClient.shared?.favorite(id: tweet.id_str!, success: { (response: Tweet) in
            print(response.text!)
            print("Liked")
            self.favoriteImageView.image = UIImage(named: "favor-icon-red")
            self.favoriteCountLabel.text = self.convertCount(count: response.favoritesCount)
            self.tweet.favoritesCount = response.favoritesCount
            self.tweet.favorited = response.favorited
        }, faliure: { (error: Error) in
            print(error.localizedDescription)
            print("already liked")
            TwitterClient.shared?.unfavorite(id: self.tweet.id_str!, success: { (response: Tweet) in
                self.favoriteImageView.image = UIImage(named: "favor-icon")
                self.favoriteCountLabel.text = self.convertCount(count: response.favoritesCount)
                self.tweet.favoritesCount = response.favoritesCount
                self.tweet.favorited = response.favorited
            }, faliure: { (error: Error) in
                //nothing
            })
        })
    }
    
    func onTapProfile(_ sender: Any) {
        print("tap profile")
        if let delegate = delegate{
            delegate.profileImageViewTapped(cell: self, user: self.tweet.user!)
        }
    }
    
}
