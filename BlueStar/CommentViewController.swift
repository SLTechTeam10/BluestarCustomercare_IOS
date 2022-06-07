//
//  CommentViewController.swift
//  BlueStar
//
//  Created by tarun.kapil on 10/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var borderLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commentTextView.delegate = self
        commentTextView.text = "Write your comment here.."
        commentTextView.textColor = UIColor.lightGray
        commentView.layer.cornerRadius = 12
        borderLabel.backgroundColor = UIColor(netHex: 0xDEDFE0)
        submitButton.setPreferences()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write your comment here.." {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write your comment here.."
            textView.textColor = UIColor.lightGray
        }
    }

    @IBAction func submitButtonAction(_ sender: AnyObject) {
        let controller = self.parent as? FeedbackViewController
        if commentTextView.text != "Write your comment here.." {
            controller?.leaveCommentButton.setTitle(commentTextView.text, for: UIControl.State())
            controller?.comment = commentTextView.text
        }
        if commentTextView.text.isEmpty {
            controller?.leaveCommentButton.setTitle("Leave a comment", for: UIControl.State())
            controller?.comment = ""
        }
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }

}
