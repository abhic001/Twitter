//
//  TwitterClient.swift
//  Twitter
//
//  Created by Abhijeet Chakrabarti on 2/27/17.
//  Copyright © 2017 Abhijeet Chakrabarti. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let shared = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com") as URL!, consumerKey: "aQkbsZS3EIOGWvE6WEU6vHh2i", consumerSecret: "JdFJolH65kL1anTFQgi0g9zkdbrucMV6XFZdO3P70q3fOhZRur")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
        
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func favorite(id: String, success: @escaping (Tweet) -> (), faliure: @escaping (Error) -> ()) {
        post("1.1/favorites/create.json", parameters: ["id": id], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let response = response as! NSDictionary
            let tweet = Tweet.init(dictionary: response)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            faliure(error)
        }
    }
    
    func unfavorite(id: String, success: @escaping (Tweet) -> (), faliure: @escaping (Error) -> ()) {
        post("1.1/favorites/destroy.json", parameters: ["id": id], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let response = response as! NSDictionary
            let tweet = Tweet.init(dictionary: response)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            faliure(error)
        }
    }
    
    func retweet(id: String, success: @escaping (Tweet) -> (), faliure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let response = response as! NSDictionary
            let tweet = Tweet.init(dictionary: response)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            faliure(error)
        }
    }
    
    func unretweet(id: String, success: @escaping (Tweet) -> (), faliure: @escaping (Error) -> ()) {
        post("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let response = response as! NSDictionary
            let tweet = Tweet.init(dictionary: response)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            faliure(error)
        }
    }
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.shared!.deauthorize()
        TwitterClient.shared!.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitterapp://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            //print("Got token")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")!
            UIApplication.shared.openURL(url as URL)
            
            
        }, failure: { (error:Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure!(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in

            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
                
            }, failure: { (error: Error) in
                self.loginFailure?(error)
                
            })
            
        }, failure: { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
}
