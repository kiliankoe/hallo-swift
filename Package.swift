// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "HalloSwift",
    products: [
        .executable(name: "HalloSwift", targets: ["HalloSwift"])
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.3.0")
    ],
    targets: [
        .target(
            name: "HalloSwift",
            dependencies: ["Publish"]
        )
    ]
)