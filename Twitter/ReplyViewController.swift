//
//  ReplyViewController.swift
//  Twitter App
//
//  Created by Yinrong Liang on 2/25/17.
//  Copyright © 2017 Yinrong Liang. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {

    @IBOutlet weak var replyTextView: UITextView!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replyTextView.text = "@\(tweet!.screenName!) "
        replyTextView.becomeFirstResponder()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapSend(_ sender: Any) {
        TwitterClient.shared?.reply(id: (tweet?.id_str)!, text: replyTextView.text, success: { (response: Tweet) in
            /*
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
            self.present(vc, animated: true, completion: nil) */
            
            //self.dismiss(animated: true, completion: nil)
            
            self.navigationController!.popViewController(animated: true)
            
        }, faliure: { (error: Error) in
            
            let errorAlertController = UIAlertController(title: "Error!", message: "Already replied to this Tweet", preferredStyle: .alert)
            let errorAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                //dismiss
            }
            errorAlertController.addAction(errorAction)
            self.present(errorAlertController, animated: true)
            
        })
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
