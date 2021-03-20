#
# Be sure to run `pod lib lint APPropertyWrappers.podspec` to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'APPropertyWrappers'
  s.version          = '2.0.1'
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

  s.ios.deployment_target = '9.0'
  s.swift_versions = ['5.1']

  s.frameworks = 'Foundation', 'UIKit'
  s.source_files = 'APPropertyWrappers/Core/**/*'

  s.subspec 'Core' do |subspec|
    subspec.source_files = 'APPropertyWrappers/Core/**/*'
  end

  s.subspec 'RxSwift' do |subspec|
    subspec.source_files = 'APPropertyWrappers/RxSwift/**/*'
    subspec.dependency 'APPropertyWrappers/Core'
    subspec.dependency 'RxCocoa'
    subspec.dependency 'RxSwift'
  end
  
end
