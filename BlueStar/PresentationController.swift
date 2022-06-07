//
//  PresentationController.swift
//  Blue Star
//
//  Created by Ankush on 25/02/17.
//  Copyright © 2017 BlueStar. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {

    var dimmingView: UIButton!
    var height: CGFloat = 0
    
    func getDimmingView() -> UIButton {
        let button = UIButton(frame: (presentingViewController.view.bounds))
        button.backgroundColor = UIColor(white: CGFloat(0), alpha: CGFloat(0.7))
        button.addTarget(self, action: #selector(self.dimmingViewClicked), for: .touchUpInside)
        return button
    }
    
    public override func presentationTransitionWillBegin() {
        let presentedView: UIView? = self.presentedViewController.view
        presentedView?.layer.shadowColor = UIColor.black.cgColor
        presentedView?.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(0))
        presentedView?.layer.shadowOpacity = 0.0
        self.dimmingView = self.getDimmingView()
        self.dimmingView.alpha = 0
        self.containerView?.addSubview(self.dimmingView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: {(_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.dimmingView.alpha = 1
        }, completion: { _ in })
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: {(_ context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.dimmingView.alpha = 0
        }, completion: { _ in })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.dimmingView.removeFromSuperview()
        }
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        let frame = CGRect(x: CGFloat(20), y: CGFloat(((self.containerView?.frame.size.height)! - height) / 2.75), width: CGFloat((self.containerView?.frame.size.width)! - 40), height: CGFloat(height))
        return frame
    }
    
    override func containerViewWillLayoutSubviews() {
        self.dimmingView.frame = (self.containerView?.bounds)!
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
    }
    
    @objc func dimmingViewClicked(_ sender: Any) {
        if((self.presentedView?.subviews.last?.isKind(of: ProblemDescriptionView.self))!){
            print("Description view present")
            self.presentedView?.endEditing(true)
        }else{
            print("Description view not present")
            if (self.presentedView != nil) {
                self.presentedViewController.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}
