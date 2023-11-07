/// A [Min-Max Heap](https://en.wikipedia.org/wiki/Min-max_heap) data structure
/// with finite capacity, where the ordering is based on the priority of an element, and surplus elements
/// are evicted or rejected on insertion when at capacity.
///
/// In a min-max heap, each node at an even level in the tree is less than or
/// equal to all its descendants, while each node at an odd level in the tree is
/// greater than or equal to all of its descendants.
///
/// The implementation is based on [Atkinson et al. 1986]:
///
/// [Atkinson et al. 1986]: https://doi.org/10.1145/6617.6621
///
/// M.D. Atkinson, J.-R. Sack, N. Santoro, T. Strothotte.
/// "Min-Max Heaps and Generalized Priority Queues."
/// *Communications of the ACM*, vol. 29, no. 10, Oct. 1986., pp. 996-1000,
/// doi:[10.1145/6617.6621](https://doi.org/10.1145/6617.6621)
///
/// - Note: `LimitedCapacityPriorityHeap` is a specialized version of the `PriorityHeap` data structure
///   that limits `count` to some maximum `capacity` based on an `evictionPolicy`.
public struct LimitedCapacityPriorityHeap<Element: Prioritizable> {
    @usableFromInline
    internal var _storage: PriorityHeap<Element> = []
    
    /// The maximum number of elements that the heap can hold.
    public let capacity: Int

    /// The policy to use when the heap is at capacity and a new element is inserted.
    public typealias EvictionPolicy = CapacityLimit.EvictionPolicy
    
    /// The eviction policy of the heap.
    public let evictionPolicy: CapacityLimit.EvictionPolicy
    
    /// Creates an empty heap with the specified capacity and eviction policy.
    ///
    /// - Parameters:
    ///   - capacity: The maximum number of elements that the heap can hold.
    ///   - evictionPolicy: The policy to use when the heap is at capacity and a new element is inserted.
    ///
    /// - Complexity: O(1)
    @inlinable
    public init(capacity: Int, evictionPolicy: EvictionPolicy) {
        _storage = []
        assert(capacity > 0, "capacity must be positive")
        self.capacity = capacity
        self.evictionPolicy = evictionPolicy
    }
}

/// Conformance to the `Sendable` protocol for `LimitedCapacityPriorityHeap` where `Element` is `Sendable`.
extension LimitedCapacityPriorityHeap: Sendable where Element: Sendable {}

extension LimitedCapacityPriorityHeap {
    /// The number of additional elements that the heap can hold before it reaches its capacity.
    ///
    /// - Complexity: O(1)
    @inlinable
    public var spareCapacity: Int {
        capacity - _storage.count
    }
    
    /// Creates a heap from an existing heap with the specified capacity and eviction policy.
    /// If the initial count is greater than capacity, immediately applies the eviction policy.
    ///
    /// - Parameters:
    ///   - heap: The source heap from which elements are drawn to form the new heap.
    ///   - capacity: The maximum number of elements that the heap can hold.
    ///   - evictionPolicy: The policy to use when the heap is at capacity and a new element is inserted.
    ///
    /// - Complexity: O(`count`log(`count`)) element comparisions
    @inlinable
    public init(limiting heap: PriorityHeap<Element>, capacity: Int, evictionPolicy: EvictionPolicy) {
        _storage = heap
        _storage.evictExcess(.init(capacity: capacity, evictionPolicy: evictionPolicy))
        assert(capacity > 0, "capacity must be positive")
        self.capacity = capacity
        self.evictionPolicy = evictionPolicy
    }
}

extension PriorityHeap {
    /// Creates a heap from an existing heap.
    ///
    /// - Parameters:
    ///   - heap: The source heap from which elements are drawn to form the new heap.

    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public init(_ heap: LimitedCapacityPriorityHeap<Element>) {
        self = heap._storage
    }
}

extension LimitedCapacityPriorityHeap {
    /// The result of an attempt to insert an element into the heap.
    public typealias InsertionResult = CapacityLimit.InsertionResult
    
    /// Inserts the given element into the heap.
    ///
    /// If the heap is at capacity, the eviction policy determines the behavior:
    /// - If the policy is `evictMax` and the new element's priority is less than the maximum priority in the heap,
    ///   the element with the maximum priority is removed and the new element is inserted.
    /// - If the policy is `evictMin` and the new element's priority is greater than the minimum priority in the heap,
    ///   the element with the minimum priority is removed and the new element is inserted.
    /// - If the new element's priority does not meet the criteria for eviction, the new element is not inserted.
    ///
    /// - Parameter element: The element to insert into the heap.
    /// - Returns: The result of the insertion attempt.
    ///
    /// - Complexity: O(log(`count`)) element comparisons
    @discardableResult @inlinable @inline(__always)
    public mutating func insert(_ element: Element) -> InsertionResult<Element> {
        _storage.insert(element, limit: .init(capacity: capacity, evictionPolicy: evictionPolicy))
    }
}

extension LimitedCapacityPriorityHeap {
    /// A Boolean value indicating whether or not the heap is empty.
    ///
    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public var isEmpty: Bool {
        _storage.isEmpty
    }
    
    /// The number of elements in the heap.
    ///
    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public var count: Int {
        _storage.count
    }
    
    /// A read-only view into the underlying array.
    ///
    /// Note: The elements aren't _arbitrarily_ ordered (it is, after all, a
    /// heap). However, no guarantees are given as to the ordering of the elements
    /// or that this won't change in future versions of the library.
    ///
    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public var unordered: PriorityHeap<Element>.UnorderedView {
        _storage.unordered
    }
    
    /// Returns the element with the lowest priority, if available.
    ///
    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public func min() -> Element? {
        _storage.min()
    }
    
    /// Returns the element with the highest priority, if available.
    ///
    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public func max() -> Element? {
        _storage.max()
    }
    
    /// Removes and returns the element with the lowest priority, if available.
    ///
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    public mutating func popMin() -> Element? {
        _storage.popMin()
    }
    
    /// Removes and returns the element with the highest priority, if available.
    ///
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    public mutating func popMax() -> Element? {
        _storage.popMax()
    }
    
    /// Removes and returns the element with the lowest priority.
    ///
    /// The heap *must not* be empty.
    ///
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    public mutating func removeMin() -> Element {
        _storage.removeMin()
    }
    
    /// Removes and returns the element with the highest priority.
    ///
    /// The heap *must not* be empty.
    ///
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    public mutating func removeMax() -> Element {
        _storage.removeMax()
    }
    
    /// Replaces the minimum value in the heap with the given replacement,
    /// then updates heap contents to reflect the change.
    ///
    /// The heap must not be empty.
    ///
    /// - Parameter replacement: The value that is to replace the current
    ///   minimum value.
    /// - Returns: The original minimum value before the replacement.
    ///
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    @discardableResult
    public mutating func replaceMin(with replacement: Element) -> Element {
        _storage.replaceMin(with: replacement)
    }
    
    /// Replaces the maximum value in the heap with the given replacement,
    /// then updates heap contents to reflect the change.
    ///
    /// The heap must not be empty.
    ///
    /// - Parameter replacement: The value that is to replace the current maximum
    ///   value.
    /// - Returns: The original maximum value before the replacement.
    ///
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    @discardableResult
    public mutating func replaceMax(with replacement: Element) -> Element {
        _storage.replaceMax(with: replacement)
    }
}

// MARK: -

extension LimitedCapacityPriorityHeap {
    /// Initializes a heap from a sequence with the specified capacity and eviction policy.
    ///
    /// If the number of elements in the sequence exceeds the capacity, only the elements with the highest priorities
    /// (or lowest, depending on the eviction policy) up to the capacity will be included in the heap.
    ///
    /// - Parameters:
    ///   - elements: The sequence of elements to insert into the heap.
    ///   - capacity: The maximum number of elements that the heap can hold.
    ///   - evictionPolicy: The policy to use when the heap is at capacity and a new element is inserted.
    ///
    /// - Complexity: O(*n*), where *n* is the number of items in `elements`.
    @inlinable
    public init<S: Sequence>(_ elements: S, capacity: Int, evictionPolicy: EvictionPolicy) where S.Element == Element {
        assert(capacity > 0, "capacity must be positive")
        _storage = .init(elements)
        self.capacity = capacity
        self.evictionPolicy = evictionPolicy
    }
    
    /// Inserts the elements in the given sequence into the heap.
    ///
    /// - Parameter newElements: The new elements to insert into the heap.
    ///
    /// - Complexity: O(*n* * log(`count`)), where *n* is the length of `newElements`.
    ///
    /// - Note: This method does not indicate the `InsertionResult`. If needed,
    ///   use the non-`Sequence` variant of `insert` instead.
    @inlinable
    public mutating func insert<S: Sequence>(
        contentsOf newElements: S
    ) where S.Element == Element {
        for newElement in newElements {
            insert(newElement)
        }
    }
}

extension LimitedCapacityPriorityHeap: CustomStringConvertible {
  /// A textual representation of this instance.
  public var description: String {
      "LimitedCapacity\(_storage.description)"
  }
}

extension LimitedCapacityPriorityHeap: CustomDebugStringConvertible {
  /// A textual representation of this instance, suitable for debugging.
  public var debugDescription: String {
      description
  }
}
