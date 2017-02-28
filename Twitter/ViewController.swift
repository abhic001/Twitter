//
//  ViewController.swift
//  Twitter
//
//  Created by Abhijeet Chakrabarti on 2/27/17.
//  Copyright © 2017 Abhijeet Chakrabarti. All rights reserved.
//

import UIKit
import BDBOAuth1Manager



class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(_ sender: AnyObject) {
        
        //        TwitterClient.sharedInstance.loginWithBlock() {
        //            // go to next screen
        //        }
        
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if (user != nil) {
                //perform my segue
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            } else {
                // handle login error
            }
        }
        
        
        
        
        
    }
    
    
    
    
    
    
}

