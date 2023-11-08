import PriorityHeapModule

extension PriorityHeap {
    /// The policy to use when the heap is at capacity and a new element is inserted.
    public enum EvictionPolicy: Sendable, Hashable {
        /// Evicts the maximum priority element from the heap if needed to accommodate a new element with lower priority.
        ///
        /// - Note: When a new element has the same priority as the lowest priority element currently in the heap,
        /// the lowest priority element will remain. This is because adding the new element does not offer any advantage in terms of priority.
        case evictMax
        /// Evicts the minimum priority element from the heap if needed to accommodate a new element with higher priority.
        /// 
        /// - Note: When a new element has the same priority as the hightest priority element currently in the heap,
        /// the highest priority element will remain. This is because adding the new element does not offer any advantage in terms of priority.
        case evictMin
    }
    
    /// The result of an attempt to insert an element into the heap with capacity limitations.
    public enum LimitedCapacityInsertionResult {
        /// The heap is at capacity and the element was not inserted due to the eviction policy.
        case reject
        /// The element was inserted successfully without evicting any existing elements.
        case fit
        /// The element was inserted and an existing element was evicted according to the eviction policy.
        case evict(Element)
    }
}

extension PriorityHeap.LimitedCapacityInsertionResult: Equatable where Element: Equatable {}
extension PriorityHeap.LimitedCapacityInsertionResult: Hashable where Element: Hashable {}
extension PriorityHeap.LimitedCapacityInsertionResult: Sendable where Element: Sendable {}

extension PriorityHeap {
    /// Attempts to insert an element into the heap, adhering to the specified capacity and eviction policy.
    ///
    /// When the heap reaches its capacity, the eviction policy determines whether to evict an existing element:
    /// - `.evictMax`: Evicts the element with the maximum priority to make room for a new element with lower priority.
    ///   If the new element's priority is equal to the lowest priority in the heap, it will not be added, as it does not provide a priority advantage.
    /// - `.evictMin`: Evicts the element with the minimum priority to make room for a new element with higher priority.
    ///   If the new element's priority is equal to the highest priority in the heap, it will not be added, as it does not provide a priority advantage.
    ///
    /// - Parameters:
    ///   - element: The element to be potentially inserted.
    ///   - capacity: The maximum number of elements the heap can hold.
    ///     Must be non-negative and at least as large as the heap's current size.
    ///   - evictionPolicy: The strategy to apply when the heap is at capacity to decide whether to evict an element and insert the new one.
    /// - Returns: The result of the insertion attempt, indicating whether the new element fit, an existing element was evicted, or the new element was rejected.
    ///
    /// - Complexity: O(log(`count`)) for element comparisons.
    /// - Note: If the heap's capacity is set to 0, the method will always reject the new element, regardless of its priority.
    @discardableResult @inlinable
    public mutating func attemptInsert(
        _ element: Element,
        capacity: Int,
        evictionPolicy: EvictionPolicy
    ) -> LimitedCapacityInsertionResult {
        precondition(capacity >= count, "insertion requires capacity greater than or equal to current count")
        guard capacity == count else {
            insert(element)
            return .fit
        }
        guard capacity > 0 else {
            return .reject
        }
        switch evictionPolicy {
        case .evictMax:
            guard let evicted = replaceMax(with: element, if: >) else { return .reject }
            return .evict(evicted)
        case .evictMin:
            guard let evicted = replaceMin(with: element, if: <) else { return .reject }
            return .evict(evicted)
        }
    }
    
    /// Evicts elements from the heap until its size does not exceed the specified capacity, based on the given eviction policy.
    ///
    /// This method reduces the heap's size by removing elements according to the chosen eviction policy:
    /// - `.evictMax`: Removes the elements with the highest priority until the heap's size is within the specified capacity.
    /// - `.evictMin`: Removes the elements with the lowest priority until the heap's size is within the specified capacity.
    ///
    /// - Parameters:
    ///   - capacity: The maximum number of elements that the heap is allowed to contain after eviction.
    ///     The capacity must be non-negative.
    ///   - evictionPolicy: The policy that determines which elements to evict when the heap exceeds the specified capacity.
    ///
    /// - Complexity: O(log(`count`)) for element comparisons.
    ///
    /// - Note: If `capacity` is equal to or greater than the current heap size, no elements will be evicted.
    @inlinable
    public mutating func evictExcess(capacity: Int, evictionPolicy: EvictionPolicy) {
        precondition(capacity >= 0, "evicting excess requires non-negative capacity")
        switch evictionPolicy {
        case .evictMax:
            while count > capacity { _ = removeMax() }
        case .evictMin:
            while count > capacity { _ = removeMin() }
        }
    }
}

extension PriorityHeap {
    /// Replaces the element with the maximum priority in the heap with a new element if a specified condition is met.
    ///
    /// This method first checks if the replacement should occur by comparing the priority of the maximum element in the heap
    /// with the priority of the new element using the provided `shouldReplace` closure. If the condition returns `true`,
    /// the element with the maximum priority is replaced with the new element.
    ///
    /// The heap must not be empty.
    ///
    /// - Parameters:
    ///   - replacement: The new element that may replace the current maximum element in the heap.
    ///   - shouldReplace: A closure that takes the existing maximum element's priority and the replacement element's priority and returns
    ///   a Boolean value indicating whether the replacement should occur. The closure must return `true` to proceed with the replacement.
    /// - Returns: The element that was replaced and removed from the heap, or `nil` if the replacement did not occur.
    ///
    /// - Complexity: O(log(`count`)) for element comparisons.
    public mutating func replaceMax(with replacement: Element, if shouldReplace: (_ existing: Element.Priority, _ replacement: Element.Priority) -> Bool) -> Element? {
        precondition(!isEmpty, "No element to replace")
        guard shouldReplace(max()!.priority, replacement.priority) else { return nil }
        return replaceMax(with: replacement)
    }
    
    /// Replaces the element with the minimum priority in the heap with a new element if a specified condition is met.
    ///
    /// This method first checks if the replacement should occur by comparing the priority of the minimum element in the heap
    /// with the priority of the new element using the provided `shouldReplace` closure. If the condition returns `true`,
    /// the element with the minimum priority is replaced with the new element.
    ///
    /// The heap must not be empty.
    ///
    /// - Parameters:
    ///   - replacement: The new element that may replace the current minimum element in the heap.
    ///   - shouldReplace: A closure that takes the existing minimum element's priority and the replacement element's priority and returns
    ///   a Boolean value indicating whether the replacement should occur. The closure must return `true` to proceed with the replacement.
    /// - Returns: The element that was replaced and removed from the heap, or `nil` if the replacement did not occur.
    ///
    /// - Complexity: O(log(`count`)) for element comparisons.
    public mutating func replaceMin(with replacement: Element, if shouldReplace: (_ existing: Element.Priority, _ replacement: Element.Priority) -> Bool) -> Element? {
        precondition(!isEmpty, "No element to replace")
        guard shouldReplace(min()!.priority, replacement.priority) else { return nil }
        return replaceMin(with: replacement)
    }
}
