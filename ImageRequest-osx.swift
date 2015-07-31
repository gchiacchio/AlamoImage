//
//  ImageRequest.swift
//  AlamoImage
//
//  Created by Guillermo Chiacchio on 6/4/15.
//
//

import Alamofire
import Foundation

#if os(OSX)

/**
Alamofire.Request extension to support a handler for images. OSX Only.
*/
extension Request {
    
    class func imageResponseSerializer() -> GenericResponseSerializer<NSImage> {
        return GenericResponseSerializer { request, response, data in
            if data == nil {
                return (nil, nil)
            }
            
            let image = NSImage(data: data!)
            
            return (image, nil)
        }
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the NSImage object, if one could be created from the URL response and data, and any error produced while creating the NSImage object.
    
    :returns: The request.
    */
    public func responseImage(completionHandler: (NSURLRequest, NSHTTPURLResponse?, NSImage?, NSError?) -> Void) -> Self {
        return response(serializer: Request.imageResponseSerializer(), completionHandler: completionHandler)
    }
}

/**
NSImage extension to support and handle the request of a remote image, to be downloaded. OSX Only.
*/
extension NSImage {
    /**
    Creates a request using `Alamofire`, and returns the image into the success closure. This method automatically adds and retrieves the image to/from the global `AlamoImage.imageCache` cache instance if any.
    If you just want to get the image, without taking care of errors or requests, look for the shorter version.
    
    :param: URLStringConv The URL for the image.
    :param: success The code to be executed if the request finishes successfully.
    :param: failure The code to be executed if the request finishes with some error.
    :returns: The request created or .None if was retrieved from the global `AlamoImage.imageCache` cache instance.
    */
    public static func requestImage(URLStringConv: URLStringConvertible,
        success: (NSURLRequest?, NSHTTPURLResponse?, NSImage?) -> Void,
        failure: (NSURLRequest?, NSHTTPURLResponse?, NSError?) -> Void = { (_, _, _) in }
        ) -> Request?
    {
        if let cachedImage = imageCache?.objectForKey(URLStringConv.URLString) as? NSImage {
            success(nil, nil, cachedImage)
            return .None
        } else {
            return Alamofire.request(.GET, URLStringConv).validate().responseImage()
                {
                    (req, response, image, error) in
                    if error == nil && image != nil {
                        imageCache?.setObject(image!, forKey: URLStringConv.URLString)
                        success(req, response, image)
                    } else {
                        failure(req, response, error)
                    }
            }
        }
    }
    
    /**
    Creates a request using `Alamofire`, and returns the image into the success closure. This method automatically adds and retrieves the image to/from the global `AlamoImage.imageCache` cache instance if any.
    
    Example:
    
    `NSImage.requestImage(photoUrl){self.photo = $0}`
    
    
    :param: URLStringConv The URL for the image.
    :param: success The code to be executed if the request finishes successfully.
    :returns: The request created or .None if was retrieved from the global `AlamoImage.imageCache` cache instance.
    */
    public static func requestImage(URLStringConv: URLStringConvertible,
        success: (NSImage?) -> Void) -> Request?
    {
        return requestImage(URLStringConv, success: { _,_,image in success(image)}, failure: {_,_,_ in})
    }
}

#endif
