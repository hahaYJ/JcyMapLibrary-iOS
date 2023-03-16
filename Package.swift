// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JCYMapLibrary",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "JCYMapLibrary",
            targets: ["JCYMapLibrary"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "arcgis-runtime-ios", url: "https://github.com/Esri/arcgis-runtime-ios.git", .upToNextMajor(from: "100.15.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "JCYMapLibrary",
            dependencies: [.productItem(name: "ArcGIS", package: "arcgis-runtime-ios", moduleAliases: nil, condition: nil)],
            path: "JcyMapLibrary/gis",
            resources: [Resource.copy("JcyMapLibrary/Assets.xcassets")]),
    ]
)
