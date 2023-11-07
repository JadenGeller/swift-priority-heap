# PriorityHeap

[`PriorityHeap`](https://jadengeller.github.io/swift-priority-heap/documentation/priorityheapmodule/priorityheap) is a Swift data structure that extends the functionality of the [`Heap`](https://github.com/apple/swift-collections/blob/main/Documentation/Heap.md) data structure from the [swift-collections](https://github.com/apple/swift-collections) package. It utilizes the [`Prioritizable`](https://jadengeller.github.io/swift-priority-heap/documentation/priorityheapmodule/prioritizable) protocol to allow elements to be ordered based on their inherent priority. This is particularly useful when the elements themselves are not directly comparable, or when you want to order the elements based on a specific property.

## Prioritizable Protocol

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

## PriorityHeap

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

## LimitedCapacityPriorityHeap

[`LimitedCapacityPriorityHeap`](https://jadengeller.github.io/swift-priority-heap/documentation/priorityheapmodule/limitedcapacitypriorityheap) is a specialized version of `PriorityHeap` with a fixed maximum capacity. When the heap is full, it uses an eviction policy (`evictMax` or `evictMin`) to decide which element to remove upon the insertion of a new element.

Consider a scenario where a server can only handle a certain number of requests at a time. When the server is at capacity, it needs to decide which request to drop based on priority:

```swift
var requestHeap = LimitedCapacityPriorityHeap<Request>(capacity: 3, evictionPolicy: .evictMin)
requestHeap.insert(Request(id: "1", priority: 5)) // Returns .fit
requestHeap.insert(Request(id: "2", priority: 3)) // Returns .fit
requestHeap.insert(Request(id: "3", priority: 2)) // Returns .fit
requestHeap.insert(Request(id: "4", priority: 4)) // Returns .evict(Request(id: "3", priority: 2))
requestHeap.insert(Request(id: "5", priority: 1)) // Returns .reject

while let request = requestHeap.popMax() {
    print(request.id)
}
// Prints "1"
// Prints "4"
// Prints "2"
```

## Installation

To use PriorityHeap in your project, you need to add it to the dependencies in your `Package.swift` file. Please note that this package depends on a preview version of swift-collections, which is currently unstable and may change without notice. It is not recommended to use this in production code yet, but it is suitable for experimental projects.

Here's how to include PriorityHeap in your Swift package:

```swift
.package(url: "https://github.com/JadenGeller/swift-priority-heap", branch: "release/0.3.1")
```

Then, include it in your target dependencies:

```swift
.target(name: "YourTarget", dependencies: ["PriorityHeap"]),
```

Remember, the swift-collections dependency is still in a preview phase on the release/1.1 branch. Its API and implementation are subject to change, so please use it with caution.

## Swift Collections

PriorityHeap is backed by the Heap data structure from the [swift-collections](https://github.com/apple/swift-collections) package. Swift Collections is an open-source project from Apple introducing new data structures to Swift. For more detailed information about the performance and characteristics of the underlying Heap data structure, you can refer to the [official documentation](https://github.com/apple/swift-collections/blob/main/Documentation/Heap.md#performance).
