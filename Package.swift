// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "PriorityHeap",
    products: [
        .library(
            name: "PriorityHeap",
            targets: ["PriorityHeap"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", branch: "release/1.1"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(name: "PriorityHeap", dependencies: [
            .product(name: "HeapModule", package: "swift-collections"),
        ]),
    ]
)
