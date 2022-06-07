//
//  ProgressShowHide.swift
//  BlueStar
//
//  Created by tarun.kapil on 06/09/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import Foundation
import UIKit

func showPlaceHolderView() {
    let controller:UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PlaceHolderView")
    controller.view.frame = self.view.bounds;
    controller.view.tag = 100
    controller.view.backgroundColor = UIColor(white: 0.1, alpha: 0.65)
    controller.willMoveToParentViewController(self)
    self.view.addSubview(controller.view)
    self.addChildViewController(controller)
    controller.didMoveToParentViewController(self)
}

func hidePlaceHolderView() {
    if let viewWithTag = self.view.viewWithTag(100) {
        viewWithTag.removeFromSuperview()
    }
}