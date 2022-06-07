//
//  ImageView.swift
//  BlueStar
//
//  Created by tarun.kapil on 23/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

extension UIImageView {
    public func imageFromUrl(_ urlString: String) {
        if let url = URL(string: urlString) {
            /***** ankush comment *****/
            //need to check
//            let request = URLRequest(url: url)
//            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {
//                (response: URLResponse?, data: Data?, error: NSError?) -> Void in
//                if let imageData = data as Data? {
//                    self.image = UIImage(data: imageData)
//                }
//                
//                //print("image loading error>> \(error?.description)")
//            } as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void as! (URLResponse?, Data?, Error?) -> Void
        }
    }
    
//    public func imageFromUrl(link:String) {
//        NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:link)!, completionHandler: {
//            (data, response, error) -> Void in
//            dispatch_async(dispatch_get_main_queue()) {
//                //self.contentMode =  contentMode
//                if let data = data { self.image = UIImage(data: data) }
//            }
//        }).resume()
//    }
}
