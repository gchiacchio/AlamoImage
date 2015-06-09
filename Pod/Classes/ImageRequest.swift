//
//  ImageRequest.swift
//  AlamoImage
//
//  Created by Guillermo Chiacchio on 6/4/15.
//
//

import Alamofire
import Foundation

public var imageCache: NSCache? = nil

extension Alamofire.Request {

    class func imageResponseSerializer() -> Serializer {
        return { request, response, data in
            if data == nil {
                return (nil, nil)
            }

            let image = UIImage(data: data!, scale: UIScreen.mainScreen().scale)

            return (image, nil)
        }
    }

    public func responseImage(completionHandler: (NSURLRequest, NSHTTPURLResponse?, UIImage?, NSError?) -> Void) -> Self {
        return response(serializer: Request.imageResponseSerializer(), completionHandler: { (request, response, image, error) in
            completionHandler(request, response, image as? UIImage, error)
        })
    }
}
