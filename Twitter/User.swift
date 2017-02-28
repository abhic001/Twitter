//
//  User.swift
//  Twitter
//
//  Created by Abhijeet Chakrabarti on 2/27/17.
//  Copyright © 2017 Abhijeet Chakrabarti. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "CurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"


class User: NSObject {

    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        
        
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: userDidLogoutNotification), object: nil)
    
    }
    
    class var currentUser: User? {
        get {
        if _currentUser == nil {
            let data = UserDefaults.standard.object(forKey: currentUserKey) as? Data
        if let data = data {
            let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
        _currentUser = User(dictionary: dictionary)
        
        }
        
        }
        
        
        
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                
                let data = try! JSONSerialization.data(withJSONObject: (user!.dictionary), options: [])
                
                UserDefaults.standard.set(data, forKey: currentUserKey)
                
            } else {
                UserDefaults.standard.set(nil, forKey: currentUserKey)
                
            }
            UserDefaults.standard.synchronize()

        }
    }
}







