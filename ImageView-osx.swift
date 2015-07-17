//
//  ImageView.swift
//  AlamoImage
//
//  Created by Guillermo Chiacchio on 6/5/15.
//
//

import Alamofire
import Foundation

#if os(OSX)

/**
Extension to support and handle the request of a remote image, to be downloaded and set. OSX Only.
*/
extension NSImageView {
    /// A reference to handle the `Request`, if any, for the `NSImage` instance.
    public var request: Alamofire.Request? {
        get {
            return associatedObject(self, &imageRequestPropertyKey) as! Alamofire.Request?
        }
        set {
            setAssociatedObject(self, &imageRequestPropertyKey, newValue)
        }
    }
    
    /**
    Creates a request using `Alamofire`, and sets the returned image into the `NSImageview` instance. This method cancels any previous request for the same `NSImageView` instance. It also automatically adds and retrieves the image to/from the global `AlamoImage.imageCache` cache instance if any.
    
    :param: URLStringConv The URL for the image.
    :param: placeholder An optional `NSImage` instance to be set until the requested image is available.
    :param: success The code to be executed if the request finishes successfully.
    :param: failure The code to be executed if the request finishes with some error.
    
    */
    public func requestImage(URLStringConv: URLStringConvertible, placeholder: NSImage? = nil,
        success _success: (NSImageView, NSURLRequest?, NSHTTPURLResponse?, NSImage?) -> Void = { (imageView, _, _, theImage) in
            
            imageView.image = theImage
        },
        failure _failure: (NSImageView, NSURLRequest?, NSHTTPURLResponse?, NSError?) -> Void = { (_, _, _, _) in }
        )
    {
        if (placeholder != nil) {
            self.image = placeholder
        }
        self.request?.cancel()
        
        self.request = NSImage.requestImage(URLStringConv,
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
