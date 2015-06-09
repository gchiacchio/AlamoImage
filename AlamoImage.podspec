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
  s.version          = "0.1.1"
  s.summary          = "Image downloading with Alamofire"
  s.description      = <<-DESC
                       AlamoImage is a simple way to deal with image downloading using Alamofire

                       DESC
  s.homepage         = "https://github.com/gchiacchio/AlamoImage"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Guillermo Chiacchio" => "guillermo.chiacchio@gmail.com" }
  s.source           = { :git => "https://github.com/gchiacchio/AlamoImage.git", :tag => s.version.to_s }
  s.default_subspec  = "Core"
  s.social_media_url = 'https://twitter.com/Gvi113'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.subspec "Core" do |core|
    core.source_files = 'Pod/Classes/ImageRequest.swift'
    core.dependency 'Alamofire', '~> 1.2'
  end

  s.subspec "ImageView" do |imageView|
    imageView.source_files = 'Pod/Classes/ImageView.swift'
    imageView.frameworks = 'UIKit'
    imageView.dependency 'Alamofire', '~> 1.2'
    imageView.dependency 'AlamoImage/Core'
  end

end
