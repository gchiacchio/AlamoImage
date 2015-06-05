#
# Be sure to run `pod lib lint AlamoImage.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "AlamoImage"
  s.version          = "0.2.0"
  s.summary          = "Image downloading with Alamofire"
  s.description      = <<-DESC
                       AlamoImage is a simple way to deal with image downloading using Alamofire

                       DESC
  s.homepage         = "https://github.com/gchiacchio/AlamoImage"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Guillermo Chiacchio" => "guillermo.chiacchio@gmail.com" }
  # s.source           = { :git => "https://github.com/gchiacchio/AlamoImage.git", :tag => s.version.to_s }
  s.source           = { :path => '/Users/guillermo/Developer/personal/AlamoImage', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'AlamoImage' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'Alamofire', '~> 1.2'
end
