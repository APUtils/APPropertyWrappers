// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APPropertyWrappers",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13),
        .tvOS(.v12),
        .watchOS(.v4),
    ],
    products: [
        .library(
            name: "APPropertyWrappers",
            targets: ["APPropertyWrappers"]
        ),
        .library(
            name: "RxAPPropertyWrappers",
            targets: ["RxAPPropertyWrappers"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/anton-plebanovich/RoutableLogger.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/APUtils/APExtensions.git", .upToNextMajor(from: "15.0.0")),
        .package(url: "https://github.com/APUtils/RxUtils.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
    ],
    targets: [
        .target(
            name: "RxAPPropertyWrappers",
            dependencies: [
                "APPropertyWrappers",
                .product(name: "RoutableLogger", package: "RoutableLogger"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxRelay", package: "RxSwift"),
                .product(name: "RxSwift", package: "RxSwift"),
                "RxUtils",
            ],
            path: "APPropertyWrappers",
            exclude: [],
            sources: ["RxSwift"],
            resources: [
                .process("Privacy/APPropertyWrappers.RxSwift/PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [
                .define("SPM"),
            ]
        ),
        .target(
            name: "APPropertyWrappers",
            dependencies: [
                .product(name: "RoutableLogger", package: "RoutableLogger"),
                .product(name: "APExtensionsOptionalType", package: "APExtensions"),
            ],
            path: "APPropertyWrappers",
            exclude: [],
            sources: ["Core"],
            resources: [
                .process("Privacy/APPropertyWrappers.Core/PrivacyInfo.xcprivacy")
            ],
            swiftSettings: [
                .define("SPM"),
            ]
        ),
    ]
)
