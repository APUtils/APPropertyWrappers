# APPropertyWrappers

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/APPropertyWrappers.svg?style=flat)](http://cocoapods.org/pods/APPropertyWrappers)
[![License](https://img.shields.io/cocoapods/l/APPropertyWrappers.svg?style=flat)](http://cocoapods.org/pods/APPropertyWrappers)
[![Platform](https://img.shields.io/cocoapods/p/APPropertyWrappers.svg?style=flat)](http://cocoapods.org/pods/APPropertyWrappers)
[![CI Status](http://img.shields.io/travis/APUtils/APPropertyWrappers.svg?style=flat)](https://travis-ci.org/APUtils/APPropertyWrappers)

Simple and complex property wrappers for native `Swift` and for `RxSwift`.

## Example

Clone the repo and then open `Carthage Project/APPropertyWrappers.xcodeproj`

## Installation

#### Carthage

Please check [official guide](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos)

Cartfile:

```
github "APUtils/APPropertyWrappers" ~> 2.0
```

You should later add both `APPropertyWrappers` and `RoutableLogger` frameworks to your project.

#### CocoaPods

APPropertyWrappers is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'APPropertyWrappers', '~> 2.0'
```

To add `RxSwift` property wrappers additionally add:

```ruby
pod 'APPropertyWrappers/RxSwift', '~> 2.0'
```

## Usage

```swift
@UserDefaultCodable(key: "ViewController_runCounter", defaultValue: 0)
var runCounter: Int
```

See example and test projects for more details.

## Contributions

Any contribution is more than welcome! You can contribute through pull requests and issues on GitHub.

## Author

Anton Plebanovich, anton.plebanovich@gmail.com

## License

APPropertyWrappers is available under the MIT license. See the LICENSE file for more info.
