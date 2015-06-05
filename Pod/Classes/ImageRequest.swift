//
//  ImageDonwload.swift
//  Alamofire
//
//  Created by Guillermo Chiacchio on 6/4/15.
//  Copyright (c) 2015 Alamofire. All rights reserved.
//

import UIKit
import Alamofire
import Foundation


func setAssociatedObject(object: AnyObject!, key: UnsafePointer<Void>, value: AnyObject!) {
    objc_setAssociatedObject(object, key, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
}

func associatedObject(object: AnyObject!, key: UnsafePointer<Void>) -> AnyObject! {
    return objc_getAssociatedObject(object, key)
}

@objc public protocol ResponseObjectSerializable {
    init(response: NSHTTPURLResponse, representation: AnyObject)
}

var imageCachePropertyKey = "Alamofire.ImageCache"
extension Alamofire.Request {

    static var imageCache: NSCache? {
        get {
        return associatedObject(self, &imageCachePropertyKey) as! NSCache?
        }
        set {
            setAssociatedObject(self, &imageCachePropertyKey, newValue)
        }
    }

    class func imageResponseSerializer() -> Serializer {
        return { request, response, data in
            if data == nil {
                return (nil, nil)
            }

            let image = UIImage(data: data!, scale: UIScreen.mainScreen().scale)

            return (image, nil)
        }
    }

    func responseImage(completionHandler: (NSURLRequest, NSHTTPURLResponse?, UIImage?, NSError?) -> Void) -> Self {
        return response(serializer: Request.imageResponseSerializer(), completionHandler: { (request, response, image, error) in
            completionHandler(request, response, image as? UIImage, error)
        })
    }
}

var imageRequestPropertyKey = "Alamofire.ImageRequest"
extension UIImageView {
    var request: Alamofire.Request? {
        get {
            return associatedObject(self, &imageRequestPropertyKey) as! Alamofire.Request?
        }
        set {
            setAssociatedObject(self, &imageRequestPropertyKey, newValue)
        }
    }

    func requestImage(URLStringConv: URLStringConvertible, placeholder: UIImage? = nil,
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
