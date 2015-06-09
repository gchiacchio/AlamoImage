//
//  ImageView.swift
//  AlamoImage
//
//  Created by Guillermo Chiacchio on 6/5/15.
//
//

import UIKit
import Alamofire
import Foundation
import AlamoImage

func setAssociatedObject(object: AnyObject!, key: UnsafePointer<Void>, value: AnyObject!) {
    objc_setAssociatedObject(object, key, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
}

func associatedObject(object: AnyObject!, key: UnsafePointer<Void>) -> AnyObject! {
    return objc_getAssociatedObject(object, key)
}

var imageRequestPropertyKey = "AlamoImage.ImageView.Request"
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
        if let cachedImage = AlamoImage.imageCache?.objectForKey(URLStringConv.URLString) as? UIImage {
            success(self, nil, nil, cachedImage)
        } else {
            self.request = Alamofire.request(.GET, URLStringConv).validate().responseImage() {
                (req, response, image, error) in
                if error == nil && image != nil {
                    AlamoImage.imageCache?.setObject(image!, forKey: URLStringConv.URLString)
                    success(self, req, response, image)
                } else {
                    failure(self, req, response, error)
                }
            }
        }
    }
}
