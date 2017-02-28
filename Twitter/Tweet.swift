//
//  Tweet.swift
//  Twitter
//
//  Created by Abhijeet Chakrabarti on 2/27/17.
//  Copyright © 2017 Abhijeet Chakrabarti. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: Date?
    var id: String?
    var retweetCount: NSNumber?
    var likeCount: NSNumber?
    var retweeted: Bool?
    var liked: Bool?
    
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id = dictionary["id_str"] as? String
        retweetCount = dictionary["retweet_count"] as? NSNumber
        likeCount = dictionary["favorite_count"] as? NSNumber
        retweeted = dictionary["retweeted"] as? Bool
        liked = dictionary["favorited"] as? Bool
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.date(from: createdAtString!)
    }
    
    class func tweetsWithArray(_ array: [NSDictionary]) -> [Tweet]{
        
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
    
}
