//
//  ProfileViewController.swift
//  Twitter App
//
//  Created by Yinrong Liang on 2/25/17.
//  Copyright © 2017 Yinrong Liang. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = User.currentUser!.name!
        backgroundImageView.setImageWith(User.currentUser!.backgroundImageUrl!)
        profileImageView.setImageWith(User.currentUser!.profileUrl!)
        screenNameLabel.text = "@\(User.currentUser!.screenname!)"
        tweetsCountLabel.text = "\(User.currentUser!.tweetsCount!)"
        followingCountLabel.text = "\(User.currentUser!.followingCount!)"
        followerCountLabel.text = "\(User.currentUser!.followersCount!)"
        
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
