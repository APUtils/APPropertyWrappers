#
# Be sure to run `pod lib lint APPropertyWrappers.podspec` to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'APPropertyWrappers'
  s.version          = '4.0.0'
  s.summary          = 'Simple and complex property wrappers for native Swift and for RxSwift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Simple and complex property wrappers for native `Swift` and for `RxSwift`. Please check `README.md` for more info.
                       DESC

  s.homepage         = 'https://github.com/APUtils/APPropertyWrappers'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anton Plebanovich' => 'anton.plebanovich@gmail.com' }
  s.source           = { :git => 'https://github.com/APUtils/APPropertyWrappers.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_versions = ['5']
  
  # 1.12.0: Ensure developers won't hit CocoaPods/CocoaPods#11402 with the resource
  # bundle for the privacy manifest.
  # 1.13.0: visionOS is recognized as a platform.
  s.cocoapods_version = '>= 1.13.0'

  s.frameworks = 'Foundation', 'UIKit'
  
  s.default_subspec = 'Core'

  s.subspec 'Core' do |subspec|
    subspec.source_files = 'APPropertyWrappers/Core/**/*'
    subspec.resource_bundle = {"APPropertyWrappers.Core.privacy"=>"APPropertyWrappers/Privacy/APPropertyWrappers.Core/PrivacyInfo.xcprivacy"}
    subspec.dependency 'RoutableLogger', '>= 9.1.5'
    subspec.dependency 'APExtensions/OptionalType'
  end

  s.subspec 'RxSwift' do |subspec|
    subspec.source_files = 'APPropertyWrappers/RxSwift/**/*'
    subspec.resource_bundle = {"APPropertyWrappers.RxSwift.privacy"=>"APPropertyWrappers/Privacy/APPropertyWrappers.RxSwift/PrivacyInfo.xcprivacy"}
    subspec.dependency 'APPropertyWrappers/Core'
    subspec.dependency 'RxCocoa'
    subspec.dependency 'RxSwift'
    subspec.dependency 'RxUtils'
  end
  
end
