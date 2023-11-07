/// A policy to limit the maximium capacity of a heap on `insert` or `evictExcess`.
public struct CapacityLimit: Hashable, Sendable {
    /// The maximum number of elements that the heap can hold.
    public var capacity: Int

    /// The policy to use when the heap is at capacity and a new element is inserted.
    public enum EvictionPolicy: Sendable, Hashable {
        /// Evicts the maximum priority element from the heap if needed to accommodate a new element with lower priority.
        /// This ensures that the heap retains elements with lower priority values.
        case evictMax
        /// Evicts the minimium priority element from the heap if needed to accommodate a new element with lower priority.
        /// This ensures that the heap retains elements with higher priority values.
        case evictMin
    }
    
    /// The eviction policy of the heap.
    public var evictionPolicy: EvictionPolicy
    
    /// The result of an attempt to insert an element into the heap.
    public enum InsertionResult<Element> {
        /// The heap is at capacity and the element was not inserted due to the eviction policy.
        case reject
        /// The element was inserted successfully without evicting any existing elements.
        case fit
        /// The element was inserted and an existing element was evicted according to the eviction policy.
        case evict(Element)
    }
    
    /// Creates a limit with a given capacity and evlication policy.
    public init(capacity: Int, evictionPolicy: EvictionPolicy) {
        self.capacity = capacity
        self.evictionPolicy = evictionPolicy
    }
}

extension CapacityLimit.InsertionResult: Equatable where Element: Equatable {}
extension CapacityLimit.InsertionResult: Sendable where Element: Sendable {}

extension PriorityHeap {
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
    /// - Parameter limit: The capacity and eviction policy to apply.
    /// - Returns: The result of the insertion attempt.
    ///
    /// - Complexity: O(log(`count`)) element comparisons
    @discardableResult @inlinable
    public mutating func insert(_ element: Element, limit: CapacityLimit) -> CapacityLimit.InsertionResult<Element> {
        if count < limit.capacity {
            insert(element)
            return .fit
        }
        switch limit.evictionPolicy {
        case .evictMax:
            guard element.priority < max()!.priority else { return .reject }
            return .evict(replaceMax(with: element))
        case .evictMin:
            guard element.priority > min()!.priority else { return .reject }
            return .evict(replaceMin(with: element))
        }
    }
    
    /// If heap count exceeds the capacity, evicts elements according to the eviction policy.
    ///
    /// - Parameter limit: The capacity and eviction policy to apply.
    /// 
    /// - Complexity: O(`count`log(`count`)) element comparisons
    @inlinable
    public mutating func evictExcess(_ limit: CapacityLimit) {
        switch limit.evictionPolicy {
        case .evictMax:
            while count > limit.capacity { _ = removeMax() }
        case .evictMin:
            while count > limit.capacity { _ = removeMin() }
        }
    }
}
