// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JCYMap",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "JCYMap",
            targets: ["JcyMapFramework", "JcyMapEmpty"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Esri/arcgis-runtime-ios.git", from: "100.15.1")
    ],
    targets: [
        .binaryTarget(name: "JcyMapFramework",
                      path: "JcyMapFramework.xcframework"),
        
        .target(
            name: "JcyMapEmpty",
            dependencies: [.productItem(name: "ArcGIS", package: "arcgis-runtime-ios", moduleAliases: nil, condition: nil)],
            path: "JcyMapLibrary/empty"),
    ]
)
