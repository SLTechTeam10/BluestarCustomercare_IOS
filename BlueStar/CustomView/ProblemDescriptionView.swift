//
//  ProblemDescriptionView.swift
//  BlueStar
//
//  Created by Avinash Yalgonde on 03/03/20.
//  Copyright © 2020 BlueStar. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ProblemDescriptionView: UIView {
    
    var actionDelegate : ProblemDescriptionViewActionHandler? = nil
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var descriptionTextview: IQTextView!
    @IBOutlet weak var pdCancelButton: UIButton!
    @IBOutlet weak var pdOkButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         //commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ProblemDescriptionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth ]
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        descriptionTextview.layer.borderColor = UIColor.darkGray.cgColor
        descriptionTextview.layer.borderWidth = 1.0
    }
    
    @IBAction func onCancelTapped(_ sender: UIButton) {
        print("c t")
    }
    @IBAction func onOKTapped(_ sender: UIButton) {
        print("o t")
    }
    
}

protocol ProblemDescriptionViewActionHandler {
    func onOKTapped()
    func onCancelTapped()
}
