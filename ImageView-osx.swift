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
    Creates a request using `Alamofire`, and sets the returned image into the `NSImageview` instance. This method cancels any previous request for the same `NSImageView` instance
    
    :param: URLStringConv The URL for the image.
    :param: placeholder An optional `NSImage` instance to be set until the requested image is available.
    :param: success The code to be executed if the request finishes successfully.
    :param: failure The code to be executed if the request finishes with some error.
    
    */
    public func requestImage(URLStringConv: URLStringConvertible, placeholder: NSImage? = nil,
        success: (NSImageView, NSURLRequest?, NSHTTPURLResponse?, NSImage?) -> Void = { (imageView, _, _, theImage) in
            
            imageView.image = theImage
        },
        failure: (NSImageView, NSURLRequest?, NSHTTPURLResponse?, NSError?) -> Void = { (_, _, _, _) in }
        )
    {
        if (placeholder != nil) {
            self.image = placeholder
        }
        self.request?.cancel()
        if let cachedImage = AlamoImage.imageCache?.objectForKey(URLStringConv.URLString) as? NSImage {
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
#endif
