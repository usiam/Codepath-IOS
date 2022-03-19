//
//  TweetViewController.swift
//  Twitter
//
//  Created by Tahamid on 3/11/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var countdownLabel: UILabel!
    let maxChar = 280
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetTextView.becomeFirstResponder()
        
        
        // styling the textView a little
        let borderColor = UIColor.init(red: 212/255, green: 212/255, blue: 212/255, alpha: 0.5)
        tweetTextView.layer.borderColor = borderColor.cgColor
        tweetTextView.layer.borderWidth = 1.0;
        tweetTextView.layer.cornerRadius = 8;
        tweetTextView.delegate = self
        
        countdownLabel.text = "0/\(maxChar)"
        // Do any additional setup after loading the view.
    }

    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty){
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
                
            }, failure: {(error) in
                print("Error in posting tweet!")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // character limit check
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Set the max character limit
        let characterLimit = maxChar
        
        
        // keeps track of length (READ AND EDIT PROPERLY)
        if(textView == tweetTextView){
            
             let strLength = textView.text?.count ?? 0
             let lngthToAdd = text.count
             let lengthCount = strLength + lngthToAdd
             countdownLabel.text = "\(lengthCount)/\(maxChar)"
            if(lengthCount >= 240){
                countdownLabel.textColor = UIColor.red
            } else{
                countdownLabel.textColor = UIColor.black
            }
          }
        

        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)

        // TODO: Update Character Count Label

        // The new text should be allowed? True/False
        return newText.count < characterLimit
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
