// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APPropertyWrappers",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13),
        .tvOS(.v11),
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
        .package(url: "https://github.com/anton-plebanovich/RoutableLogger.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/APUtils/APExtensions.git", .upToNextMajor(from: "12.0.0")),
        .package(url: "https://github.com/APUtils/RxUtils.git", .upToNextMajor(from: "4.2.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
    ],
    targets: [
        .target(
            name: "RxAPPropertyWrappers",
            dependencies: [
                "APPropertyWrappers",
                "RoutableLogger",
                "RxCocoa",
                "RxRelay",
                "RxSwift",
                "RxUtils",
            ],
            path: "APPropertyWrappers/RxSwift",
            exclude: [],
            swiftSettings: [
                .define("SPM"),
            ]
        ),
        .target(
            name: "APPropertyWrappers",
            dependencies: [
                "RoutableLogger",
                .product(name: "APExtensionsOptionalType", package: "APExtensions"),
            ],
            path: "APPropertyWrappers/Core",
            exclude: [],
            swiftSettings: [
                .define("SPM"),
            ]
        ),
    ]
)
