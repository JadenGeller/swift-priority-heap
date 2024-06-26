// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "swift-priority-heap",
    products: [
        .library(
            name: "PriorityHeapModule",
            targets: ["PriorityHeapModule"]
        ),
        .library(
            name: "PriorityHeapAlgorithms",
            targets: ["PriorityHeapAlgorithms"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.1.0"))
    ],
    targets: [
        .target(
            name: "PriorityHeapModule",
            dependencies: [
                .product(name: "HeapModule", package: "swift-collections"),
            ]
        ),
        .target(
            name: "PriorityHeapAlgorithms",
            dependencies: [
                "PriorityHeapModule",
            ]
        ),
        .testTarget(
            name: "PriorityHeapAlgorithmsTests",
            dependencies: [
                "PriorityHeapAlgorithms",
            ]
        )
    ]
)
