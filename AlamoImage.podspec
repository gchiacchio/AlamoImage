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
  s.version          = "0.3.0"
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

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.requires_arc = true

  s.subspec "Common" do |common|
    common.ios.source_files = 'Common.swift'
    common.osx.source_files = 'Common.swift'
    common.dependency 'Alamofire', '~> 1.2'
  end

  s.subspec "Core" do |core|
    core.ios.source_files = 'ImageRequest-ios.swift'
    core.osx.source_files = 'ImageRequest-osx.swift'
    core.dependency 'AlamoImage/Common'
  end

  s.subspec "ImageView" do |imageView|
    imageView.ios.source_files = 'ImageView-ios.swift'
    imageView.osx.source_files = 'ImageView-osx.swift'
    imageView.dependency 'AlamoImage/Core'
  end

end
