//
//  ImageView.swift
//  AlamoImage
//
//  Created by Guillermo Chiacchio on 6/5/15.
//
//

import Foundation
import Alamofire
import AlamoImage

/**

Image cache used by some of the extensions, if present, to speed up the request. Default value is nil, so user should set an instance to start caching images.

AlamoImage.imageCache = NSCache()

*/
public var imageCache: NSCache? = nil

func setAssociatedObject(object: AnyObject!, key: UnsafePointer<Void>, value: AnyObject!) {
    objc_setAssociatedObject(object, key, value, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
}

func associatedObject(object: AnyObject!, key: UnsafePointer<Void>) -> AnyObject! {
    return objc_getAssociatedObject(object, key)
}

var imageRequestPropertyKey = "AlamoImage.ImageView.Request"

