//
//  User.swift
//  Twitter
//
//  Created by Abhijeet Chakrabarti on 2/27/17.
//  Copyright © 2017 Abhijeet Chakrabarti. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    var backgroundImageUrl: URL?
    var followingCount: Int?
    var followersCount: Int?
    var tweetsCount: Int?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        let backgroundUrlString = dictionary["profile_background_image_url_https"] as? String
        if let backgroundUrlString = backgroundUrlString {
            backgroundImageUrl = URL(string: backgroundUrlString)
        }
        
        tagline = dictionary["description"] as? String
        followingCount = dictionary["friends_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        tweetsCount = dictionary["statuses_count"] as? Int
        
    }
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                
                let userData = defaults.object(forKey: "currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
            return _currentUser
            
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
