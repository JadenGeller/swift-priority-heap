/// A type that has an associated priority.
///
/// The `Prioritizable` protocol is used for types that have an inherent priority,
/// such as work items in a priority heap or packets in a network. The priority is represented
/// by an associated type that conforms to the `Comparable` protocol, which means
/// that priorities can be compared and ordered.
///
/// Conforming to the Prioritizable Protocol
/// ========================================
///
/// To add `Prioritizable` conformance to your custom types, you need to specify
/// an associated type that conforms to `Comparable` and provide a `priority` property.
///
/// Here's an example of a `WorkItem` structure that conforms to `Prioritizable`:
///
/// ```swift
/// struct WorkItem: Prioritizable {
///     typealias Priority = Int
///
///     let description: String
///     let priority: Priority
/// }
/// ```
///
/// In this example, `WorkItem` uses `Int` as its priority type, so work items with a higher
/// integer value are considered to have a higher priority. The `description` property
/// is a string that describes the work item.
///
/// Now that `WorkItem` conforms to `Prioritizable`, you can create a `PriorityHeap` of work items
/// and manage them based on their priority:
///
/// ```swift
/// var workHeap = PriorityHeap<WorkItem>()
/// workHeap.insert(WorkItem(description: "Do laundry", priority: 2))
/// workHeap.insert(WorkItem(description: "Buy groceries", priority: 1))
/// workHeap.insert(WorkItem(description: "Pick up kids from school", priority: 3))
///
/// while let workItem = workHeap.popMax() {
///     print(workItem.description)
/// }
/// // Prints "Pick up kids from school"
/// // Prints "Do laundry"
/// // Prints "Buy groceries"
/// ```
///
/// Note that the `popMax()` method provided by the `PriorityHeap` is used in this
/// example to retrieve the work items in descending order of priority.
///
/// - Note: The associated type `Priority` must conform to the `Comparable` protocol.
///   This allows priorities to be compared and ordered. The choice of the `Priority`
///   type depends on the specific semantics of the conforming type. For example, a
///   task queue might use an integer priority, where a higher number indicates a
///   higher priority, while a network packet might use a timestamp to prioritize
///   older packets.
public protocol Prioritizable {

    /// The type representing the priority of conforming types.
    ///
    /// The `Priority` type must conform to the `Comparable` protocol.
    associatedtype Priority: Comparable

    /// The priority of the conforming type.
    ///
    /// Higher priorities are given precedence over lower ones.
    var priority: Priority { get }
}
