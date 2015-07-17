//
//  ImageView.swift
//  AlamoImage
//
//  Created by Guillermo Chiacchio on 6/5/15.
//
//

import Alamofire
import Foundation

#if os(iOS)

/**
UIImageView extension to support and handle the request of a remote image, to be downloaded and set. iOS Only.
*/
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
    Creates a request using `Alamofire`, and sets the returned image into the `UIImageview` instance. This method cancels any previous request for the same `UIImageView` instance. It also automatically adds and retrieves the image to/from the global `AlamoImage.imageCache` cache instance if any.
    
    :param: URLStringConv The URL for the image.
    :param: placeholder An optional `UIImage` instance to be set until the requested image is available.
    :param: success The code to be executed if the request finishes successfully.
    :param: failure The code to be executed if the request finishes with some error.
    
    */
    public func requestImage(URLStringConv: URLStringConvertible, placeholder: UIImage? = nil,
        success _success: (UIImageView, NSURLRequest?, NSHTTPURLResponse?, UIImage?) -> Void = { (imageView, _, _, theImage) in
            
            imageView.image = theImage
        },
        failure _failure: (UIImageView, NSURLRequest?, NSHTTPURLResponse?, NSError?) -> Void = { (_, _, _, _) in }
        )
    {
        if (placeholder != nil) {
            self.image = placeholder
        }
        self.request?.cancel()
        
        self.request = UIImage.requestImage(URLStringConv,
            success: { (req, res, img) in
                _success(self, req, res, img)
            },
            failure: { (req, res, err) in
                _failure(self, req, res, err)
            }
        )
    }
}

#endif
