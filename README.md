# AlamoImage

[![Version](https://img.shields.io/cocoapods/v/AlamoImage.svg?style=flat)](http://cocoapods.org/pods/AlamoImage)
[![License](https://img.shields.io/cocoapods/l/AlamoImage.svg?style=flat)](http://cocoapods.org/pods/AlamoImage)
[![Platform](https://img.shields.io/cocoapods/p/AlamoImage.svg?style=flat)](http://cocoapods.org/pods/AlamoImage)

## Usage

1. Put `import AlamoImage` at the top of your swift file
2. Have a place to put the image
		<br/>*iOS*:<pre><code>`let imageView = UIImageView()`</code></pre>
		<br/>*OSX*:<pre><code>`let imageView = NSImageView()`</code></pre>		
3. Use any of the following methods:

### Requesting an image 

```swift
let imageURL = "http://httpbin.org/image"
Alamofire.request(.GET, imageURL)
         .responseImage() { (request, _, image, error) in
             if error == nil && image != nil {
                 self.imageView.image = image
         }
}  
```

### UIImageView and NSImageView extensions

#### Basic
The simplest way to request an image is with just an **`URLStringConvertible`** instance.

```swift
let imageURL = "http://httpbin.org/image"
self.imageView.requestImage(imageURL)
```

#### Placeholder
You can also put a **`placeholder`** image. This image will be in place while the request is not responded, or if it resulted in error.

```swift
let imageURL = "http://httpbin.org/image"
let placeholder = UIImage(named:"smile.png") // In OSX use NSImage(named:"smile.png")
self.imageView.requestImage(imageURL, placeholder:placeholder)
```

#### Handling results
If you want more control to handle the views, you can also use the **`success`** and **`failure`** closure parameters. Here is an example

```swift
let imageURL = "http://httpbin.org/image"
let placeholder = UIImage(named:"smile.png") // In OSX use NSImage(named:"smile.png")
self.imageView.requestImage(imageURL, 
                            placeholder: placeholder, 
                            success: 
    { (imageView, _, _, image) in
        UIView.transitionWithView(imageView, 
                                  duration: 1.0, 
                                  options: .TransitionCrossDissolve, 
                                  animations: {
                                      imageView.image = image
                                  }, 
                                  completion: nil
                                  )   
    }
)
```

#### Canceling
Every `UIImageView` (`NSImageView` in OSX) has his own reference to the last started **`request`**. It is automatically cancelled every time a new request is made, but you can **`cancel`** it at any moment.

```swift
self.imageView.request?.cancel()
```


### UIImage and NSImage extensions
UIImageView and NSImageView extensions should be enough most of the time. But in some cases you may need to request an UIImage or NSImage without having an UIImageView or NSImageView instance.

#### Basic
The simplest way to request an image is with just an **`URLStringConvertible`** instance.

```swift
// inside some class
var photo: UIImage? // In OSX use NSImage
let imageURL = "http://httpbin.org/image"
UIImage.requestImage(imageURL){self.photo = $0} // In OSX use NSImage
```

## Requirements

- iOS 8.0+ / Mac OS X 10.9+
- Xcode 6.3

## Installation through CocoaPods

AlamoImage is available through [CocoaPods](http://cocoapods.org). To install
it, simply update your [Podfile](https://guides.cocoapods.org/using/the-podfile.html) to match the following (note that AlamoImage depends on [Alamofire](https://cocoapods.org/pods/Alamofire)):

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Alamofire', '~> 1.2'
pod 'AlamoImage'

# Include the following only if you want to use UIImageView (NSImageView) extensions with AlamoImage
pod 'AlamoImage/ImageView'
```

## Author

Guillermo Chiacchio, guillermo.chiacchio@gmail.com

## License

AlamoImage is available under the MIT license. See the LICENSE file for more info.
