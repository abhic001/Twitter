//
//  DetailedTweetViewController.swift
//  Twitter App
//
//  Created by Yinrong Liang on 2/19/17.
//  Copyright © 2017 Yinrong Liang. All rights reserved.
//

import UIKit
import AFNetworking

class DetailedTweetViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let avatarImageUrl = URL(string: (tweet?.profileImgUrlString)!)
        avatarImageView.setImageWith(avatarImageUrl!)
        
        nameLabel.text = tweet?.name
        screenNameLabel.text = "@\(tweet!.screenName!)"
        descriptionLabel.text = tweet?.text
        retweetCountLabel.text = "\(tweet!.retweetCount)"
        favoriteCountLabel.text = "\(tweet!.favoritesCount)"
        
        if(tweet!.favorited)! {
            favoriteImageView.image = #imageLiteral(resourceName: "favor-icon-red")
        } else {
            favoriteImageView.image = #imageLiteral(resourceName: "favor-icon")
        }
        
        if(tweet!.retweeted)! {
            retweetImageView.image = #imageLiteral(resourceName: "retweet-icon-green")
        } else {
            retweetImageView.image = #imageLiteral(resourceName: "retweet-icon")
        }
        
        replyImageView.image = #imageLiteral(resourceName: "reply-icon")
        
        let cellTapRecognizerRetweet = UITapGestureRecognizer(target: self, action: #selector(onTapRetweet(_:)))
        cellTapRecognizerRetweet.cancelsTouchesInView = true
        retweetImageView.addGestureRecognizer(cellTapRecognizerRetweet)
        
        let cellTapRecognizerFavorite = UITapGestureRecognizer(target: self, action: #selector(onTapFavorite(_:)))
        cellTapRecognizerFavorite.cancelsTouchesInView = true
        favoriteImageView.addGestureRecognizer(cellTapRecognizerFavorite)
        
        let cellTapRecognizerReply = UITapGestureRecognizer(target: self, action: #selector(onTapReply(_:)))
        cellTapRecognizerReply.cancelsTouchesInView = true
        replyImageView.addGestureRecognizer(cellTapRecognizerReply)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func onTapRetweet(_ sender: Any) {
        print("tapped retweet")
        
        TwitterClient.shared?.retweet(id: tweet!.id_str!, success: { (response: Tweet) in
            print(response.text!)
            print("retweet begin")
            self.retweetImageView.image = #imageLiteral(resourceName: "retweet-icon-green")
            self.retweetCountLabel.text = self.convertCount(count: response.retweetCount)
            self.tweet!.retweetCount = response.retweetCount
            self.tweet!.retweeted = true
        }, faliure: { (error: Error) in
            print(error.localizedDescription)
            print("already retweeted")
            TwitterClient.shared?.unretweet(id: self.tweet!.id_str!, success: { (response: Tweet) in
                self.retweetImageView.image = UIImage(named: "retweet-icon")
                self.retweetCountLabel.text = self.convertCount(count: response.retweetCount - 1)
                self.tweet!.retweetCount = response.retweetCount
                self.tweet!.retweeted = false
                print("unretweeted")
            }, faliure: { (error: Error) in
                //nothing
            })
        })
    }
    
    func onTapFavorite(_ sender: Any) {
        print("tapped favorite")
        
        TwitterClient.shared?.favorite(id: tweet!.id_str!, success: { (response: Tweet) in
            print(response.text!)
            print("Liked")
            self.favoriteImageView.image = #imageLiteral(resourceName: "favor-icon-red")
            self.favoriteCountLabel.text = self.convertCount(count: response.favoritesCount)
            self.tweet!.favoritesCount = response.favoritesCount
            self.tweet!.favorited = response.favorited
        }, faliure: { (error: Error) in
            print(error.localizedDescription)
            print("already liked")
            TwitterClient.shared?.unfavorite(id: self.tweet!.id_str!, success: { (response: Tweet) in
                self.favoriteImageView.image = #imageLiteral(resourceName: "favor-icon")
                self.favoriteCountLabel.text = self.convertCount(count: response.favoritesCount)
                self.tweet!.favoritesCount = response.favoritesCount
                self.tweet!.favorited = response.favorited
            }, faliure: { (error: Error) in
                //nothing
            })
        })
    }
    
    func onTapReply(_ sender: Any) {
        performSegue(withIdentifier: "ReplySegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let replyViewController = segue.destination as! ReplyViewController
        replyViewController.tweet = self.tweet
    }

}
