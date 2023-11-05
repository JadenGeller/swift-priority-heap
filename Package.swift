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
    ],
    targets: [
        .target(name: "PriorityHeap", dependencies: [
            .product(name: "HeapModule", package: "swift-collections"),
        ]),
    ]
)
