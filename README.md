# PriorityHeap

[`PriorityHeap`](https://jadengeller.github.io/swift-priority-heap/documentation/priorityheapmodule/priorityheap) is a Swift data structure that extends the functionality of the [`Heap`](https://github.com/apple/swift-collections/blob/main/Documentation/Heap.md) data structure from the [swift-collections](https://github.com/apple/swift-collections) package. It utilizes the [`Prioritizable`](https://jadengeller.github.io/swift-priority-heap/documentation/priorityheapmodule/prioritizable) protocol to allow elements to be ordered based on their inherent priority. This is particularly useful when the elements themselves are not directly comparable, or when you want to order the elements based on a specific property.

## PriorityHeapModule

The [`PriorityHeapModule`](https://jadengeller.github.io/swift-priority-heap/documentation/priorityheapmodule) provides a [`PriorityHeap`](https://jadengeller.github.io/swift-priority-heap/documentation/priorityheapmodule/priorityheap) data structure that leverages the [`Prioritizable`](https://jadengeller.github.io/swift-priority-heap/documentation/priorityheapmodule/prioritizable) protocol to manage elements according to their inherent priority.

### `Prioritizable`

The [`Prioritizable`](https://jadengeller.github.io/swift-priority-heap/documentation/priorityheapmodule/prioritizable) protocol is defined as follows:

```swift
public protocol Prioritizable {
    associatedtype Priority: Comparable
    var priority: Priority { get }
}
```

To add `Prioritizable` conformance to your custom types, you need to specify an associated type that conforms to `Comparable` and provide a `priority` property. Here's an example:

```swift
struct WorkItem: Prioritizable {
    typealias Priority = Int

    let description: String
    let priority: Priority
}
```

### `PriorityHeap`

[`PriorityHeap`](https://jadengeller.github.io/swift-priority-heap/documentation/priorityheapmodule/priorityheap) is a [Min-Max Heap](https://en.wikipedia.org/wiki/Min-max_heap) data structure, where the ordering is based on the priority of an element. It provides methods to insert elements, and to retrieve and remove the elements with the highest and lowest priority.

Here's an example of how to use it:

```swift
var workHeap = PriorityHeap<WorkItem>()
workHeap.insert(WorkItem(description: "Do laundry", priority: 2))
workHeap.insert(WorkItem(description: "Buy groceries", priority: 1))
workHeap.insert(WorkItem(description: "Pick up kids from school", priority: 3))

while let workItem = workHeap.popMax() {
    print(workItem.description)
}
// Prints "Pick up kids from school"
// Prints "Do laundry"
// Prints "Buy groceries"
```

In this example, the `popMax()` method is used to retrieve the work items in descending order of priority.

## PriorityHeapAlgorithms

The [`PriorityHeapAlgorithms`](https://jadengeller.github.io/swift-priority-heap/documentation/priorityheapalgorithms) module extends the capabilities of `PriorityHeap` with additional utilities that simplify common operations involving priority heaps.

### Merged Operations

The `PriorityHeapAlgorithms` module enhances the functionality of `PriorityHeap` by providing utilities to compare and manipulate multiple priority heaps. It allows you to determine which of two heaps has the element with the lesser or greater priority, and to perform operations like retrieving or removing the minimum or maximum element across heaps. This is particularly useful when you need to maintain a global ordering or priority across separate collections, such as merging tasks from different queues while preserving priority order.

For example, consider two priority heaps representing tasks in different departments of a company:

```swift
if let mostUrgentTask = PriorityHeap.popMax(&engineeringHeap, &marketingHeap) {
    print("Most urgent task: \(mostUrgentTask.description)")
}
```

In this scenario, `popMax` will remove and return the task with the highest priority across both departments, ensuring that the most critical work is addressed first.

### Limited Capacity

In scenarios where the number of elements must be constrained due to limited resources or specific requirements, you may specify an eviction policy (evictMax or evictMin) on insertion to ensure the heap never exceeds a set capacity. This automatically manges which elements to keep based on their priority and is particularly useful for tasks like maintaining a fixed-size cache or a keeping track the most promissing paths in a graph serach algorithm.

```swift
var frontier = PriorityHeap<Path>(evictionPolicy: .evictMax, capacity: 10)

for path in newPaths {
    let result = frontier.attemptInsert(path, capacity: 10, evictionPolicy: .evictMax)
    if case .evict(let evictedPath) = result {
        print("Evicted less promising path: \(evictedPath.description)")
    }
}
```

## Installation

To use PriorityHeap in your project, you need to add it to the dependencies in your `Package.swift` file. Please note that this package depends on a preview version of swift-collections, which is currently unstable and may change without notice. It is not recommended to use this in production code yet, but it is suitable for experimental projects.

Here's how to include PriorityHeap in your Swift package:

```swift
.package(url: "https://github.com/JadenGeller/swift-priority-heap", branch: "release/0.4.3g")
```

Then, include it in your target dependencies:
i
```swift
.target(name: "YourTarget", dependencies: ["PriorityHeap"]),
```

Remember, the swift-collections dependency is still in a preview phase on the release/1.1 branch. Its API and implementation are subject to change, so please use it with caution.

## Swift Collections

PriorityHeap is backed by the Heap data structure from the [swift-collections](https://github.com/apple/swift-collections) package. Swift Collections is an open-source project from Apple introducing new data structures to Swift. For more detailed information about the performance and characteristics of the underlying Heap data structure, you can refer to the [official documentation](https://github.com/apple/swift-collections/blob/main/Documentation/Heap.md#performance).
