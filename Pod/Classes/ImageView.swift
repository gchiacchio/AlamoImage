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
    /// A reference to handle the `Request`, if any, for the `UIImage` instance.
    public var request: Alamofire.Request? {
        get {
            return associatedObject(self, &imageRequestPropertyKey) as! Alamofire.Request?
        }
        set {
            setAssociatedObject(self, &imageRequestPropertyKey, newValue)
        }
    }
    
    /**
    Creates a request using `Alamofire`, and sets the returned image into the `UIImageview` instance. This method cancels any previous request for the same `UIImageView` instance
    
    :param: URLStringConv The URL for the image.
    :param: placeholder An optional `UIImage` instance to be set until the requested image is available.
    :param: success The code to be executed if the request finishes successfully.
    :param: failure The code to be executed if the request finishes with some error.
    
    */
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
