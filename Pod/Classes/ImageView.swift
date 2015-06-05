//
//  ImageView.swift
//  Pods
//
//  Created by Guillermo Chiacchio on 6/5/15.
//
//

import UIKit
import Alamofire
import Foundation

var imageRequestPropertyKey = "AlamoImage.ImageRequest"
extension UIImageView {
    public var request: Alamofire.Request? {
        get {
            return associatedObject(self, &imageRequestPropertyKey) as! Alamofire.Request?
        }
        set {
            setAssociatedObject(self, &imageRequestPropertyKey, newValue)
        }
    }
    
    public func requestImage(URLStringConv: URLStringConvertible, placeholder: UIImage? = nil,
        success: (UIImageView?, NSURLRequest?, NSHTTPURLResponse?, UIImage?) -> Void = { (imageView, _, _, theImage) in
            
            imageView?.image = theImage
        },
        failure: (UIImageView?, NSURLRequest?, NSHTTPURLResponse?, NSError?) -> Void = { (_, _, _, _) in }
        )
    {
        self.image = placeholder
        self.request?.cancel()
        if let cachedImage = Alamofire.Request.imageCache?.objectForKey(URLStringConv.URLString) as? UIImage {
            success(self, nil, nil, cachedImage)
        } else {
            self.request = Alamofire.request(.GET, URLStringConv).validate().responseImage() {
                (request, response, image, error) in
                if error == nil && image != nil {
                    Alamofire.Request.imageCache?.setObject(image!, forKey: URLStringConv.URLString)
                    success(self, request, response, image)
                } else {
                    failure(self, request, response, error)
                }
            }
        }
    }
}
