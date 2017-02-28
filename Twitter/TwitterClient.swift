//
//  TwitterClien.swift
//  Twitter
//
//  Created by Abhijeet Chakrabarti on 2/27/17.
//  Copyright © 2017 Abhijeet Chakrabarti. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "5GCekZZ8XOozM2Z4S116zaYsu"
let twitterConsumerSecret = "IvFYuA4LMkqo0pXVzepFqCnWx9EzraTxjr5hyOV3N5cZExUBmj"
let twitterBaseURL = URL(string: "https://api.twitter.com")




class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((_ user: User?, _ error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance!
    }
    
    func homeTimeLineWithParams(_ params: NSDictionary?, completion: @escaping (_ tweets: [Tweet]?, _ error: NSError?) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: params, success: { (task: URLSessionDataTask, response: AnyObject?) -> Void in
                //print(response)
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
                print("got timeline")
            }, failure: { (task: URLSessionDataTask?, error: NSError) -> Void in
                print(error)
                completion(tweets: nil, error: error)
        })
        
    }
    
    
    func loginWithCompletion(_ completion: @escaping (_ user: User?, _ error: NSError?) -> ()) {
        loginCompletion = completion
        
        
        //fetch my request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("got the equest token")
            let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.shared.openURL(authURL!)
            
        }) { (error: NSError!) -> Void in
            self.loginCompletion?(user: nil, error: error)
            print("failed to get request token")
        }
    }
    
    
    func retweet(_ ID: String, completion: @escaping (_ response: NSDictionary?, _ error: NSError?) -> ()) {
        post("https://api.twitter.com/1.1/statuses/retweet/\(ID).json", parameters: nil, success: { (operation: URLSessionDataTask, response: AnyObject?) -> Void in
                completion(response: response as? NSDictionary, error: nil)
                print("retweeted")
            }) { (operation: URLSessionDataTask?, error: NSError) -> Void in
                completion(response: nil, error: error)
                print("error retweeting")
                print(error)
        }
    
    }
    
    func unretweet(_ ID: String, completion: @escaping (_ response: NSDictionary?, _ error: NSError?) -> ()) {
        post("https://api.twitter.com/1.1/statuses/unretweet/\(ID).json", parameters: nil, success: { (operation: URLSessionDataTask, response: AnyObject?) -> Void in
                completion(response: response as? NSDictionary, error: nil)
                print("unretweeted")
            }) { (operation: URLSessionDataTask?, error: NSError) -> Void in
                completion(response: nil, error: error)
                print("error unretweet")
        }
    
    }
    
    func like(_ ID: String, completion: @escaping (_ response: NSDictionary?, _ error: NSError?) -> ()) {
        let parameters = NSMutableDictionary()
        parameters["id"] = ID
        
        post("1.1/favorites/create.json", parameters: parameters, success: { (operation: URLSessionDataTask!, response: AnyObject?) -> Void in
            print("liked")
            completion(response: response as? NSDictionary, error: nil)
            },
            failure: { (operation: URLSessionDataTask?, error: NSError!) -> Void in
                print("error liking")
                print(error)
                completion(response: nil, error: error)
        })
    
    }
    
    func unLike(_ ID: String, completion: @escaping (_ response: NSDictionary?, _ error: NSError?) -> ()) {
        let parameters = NSMutableDictionary()
        parameters["id"] = ID
        
        post("1.1/favorites/destroy.json", parameters: parameters, success: { (operation: URLSessionDataTask!, response: AnyObject?) -> Void in
            print("unliked")
            completion(response: response as? NSDictionary, error: nil)
            },
            failure: { (operation: URLSessionDataTask?, error: NSError!) -> Void in
                print("error unliking")
                print(error)
                completion(response: nil, error: error)
        })
        
    }
    
    
    
    func openURL(_ url: URL) {
        
       fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token")
        
        
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.get("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: URLSessionDataTask, response: AnyObject?) -> Void in
                //print("user:\(response)")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: URLSessionDataTask?, error: NSError) -> Void in
                    self.loginCompletion?(user: nil, error: error)
                    print("error getting current user")
            })
        }) { (error: NSError!) -> Void in
            print("failed to recieve access token")
//              self.loginWithCompletion(user: nil, error: error)
            self.loginCompletion?(user: nil, error: error)
        }
    }
}



