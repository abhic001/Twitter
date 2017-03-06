//
//  ComposeViewController.swift
//  Twitter App
//
//  Created by Yinrong Liang on 2/19/17.
//  Copyright © 2017 Yinrong Liang. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var dismissImageView: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    
    var count = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dismissImageView.image = #imageLiteral(resourceName: "close-icon")
        
        let cellTapRecognizerRetweet = UITapGestureRecognizer(target: self, action: #selector(onTapDismiss(_:)))
        cellTapRecognizerRetweet.cancelsTouchesInView = false
        dismissImageView.addGestureRecognizer(cellTapRecognizerRetweet)
        
        tweetTextView.becomeFirstResponder()
        tweetTextView.delegate = self
        
        countLabel.text = "\(count - tweetTextView.text.characters.count)"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onTapDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapSend(_ sender: Any) {
        
        TwitterClient.shared?.reply(id: "", text: tweetTextView.text, success: { (response: Tweet) in
            /*
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
            */
            
            self.dismiss(animated: true, completion: nil)
            
        }, faliure: { (error: Error) in
            
            let errorAlertController = UIAlertController(title: "Error!", message: "Tweet too long", preferredStyle: .alert)
            let errorAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                //dismiss
            }
            errorAlertController.addAction(errorAction)
            self.present(errorAlertController, animated: true)
            
        })
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        countLabel.text = "\(count - tweetTextView.text.characters.count)"
        
        if((count - tweetTextView.text.characters.count) <= 0) {
            
            let errorAlertController = UIAlertController(title: "Error!", message: "Tweet too long", preferredStyle: .alert)
            let errorAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                //dismiss
            }
            errorAlertController.addAction(errorAction)
            self.present(errorAlertController, animated: true)
        }
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
