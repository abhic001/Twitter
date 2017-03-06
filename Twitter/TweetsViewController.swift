//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Abhijeet Chakrabarti on 2/27/17.
//  Copyright © 2017 Abhijeet Chakrabarti. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {
    
    var tweets: [Tweet]!
    //var id_str: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        TwitterClient.shared?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            //handle error
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TwitterClient.shared?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            //handle error
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.shared?.logout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TwitterCell
        
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func profileImageViewTapped(cell: TwitterCell, user: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController {
            profileVC.user = user
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPath(for: cell)
            let tweet = self.tweets![indexPath!.row]
            
            let detailedTweetViewController = segue.destination as! DetailedTweetViewController
            detailedTweetViewController.tweet = tweet
        } else {
            //dont prepare
        }
    }
    
}
