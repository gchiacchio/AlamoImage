//
//  ImageDonwload.swift
//  Alamofire
//
//  Created by Guillermo Chiacchio on 6/4/15.
//  Copyright (c) 2015 Alamofire. All rights reserved.
//

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

var imageCachePropertyKey = "AlamoImage.ImageCache"
extension Alamofire.Request {

    public static var imageCache: NSCache? {
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
