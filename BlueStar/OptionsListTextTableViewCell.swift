//
//  OptionsListTextTableViewCell.swift
//  Blue Star
//
//  Created by Ankush on 25/02/17.
//  Copyright © 2017 BlueStar. All rights reserved.
//

import UIKit

class OptionsListTextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - View Life Cycle Methods
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        textView.text = "Reason for ticket cancellation."
    }
}

extension OptionsListTextTableViewCell : UITextViewDelegate {
    func addDoneButtonOnKeyboard() {
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(OptionsListTextTableViewCell.doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.textView.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}
