//
//  UserProfileViewController.swift
//  Twitter App
//
//  Created by Yinrong Liang on 2/25/17.
//  Copyright © 2017 Yinrong Liang. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = user!.name!
        backgroundImageView.setImageWith(user!.backgroundImageUrl!)
        profileImageView.setImageWith(user!.profileUrl!)
        screenNameLabel.text = "@\(user!.screenname!)"
        tweetCountLabel.text = "\(user!.tweetsCount!)"
        followingCountLabel.text = "\(user!.followingCount!)"
        followerCountLabel.text = "\(user!.followersCount!)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
