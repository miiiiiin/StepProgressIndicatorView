// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "StepProgressIndicatorView",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "StepProgressIndicatorView",
                 targets: ["StepProgressIndicatorView"])
    ],
    targets: [
        .target(name: "StepProgressIndicatorView",
                path: "StepProgressIndicatorView/Classes")
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
