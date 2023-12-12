// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "swift-priority-heap",
    products: [
        .library(
            name: "HeapModule",
            targets: ["HeapModule"]
        ),
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
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "HeapModule"
        ),
        .target(
            name: "PriorityHeapModule",
            dependencies: [
                "HeapModule",
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
