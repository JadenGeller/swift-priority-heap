import PriorityHeapModule

extension PriorityHeap {
    /// Represents the outcome of comparing two elements from PriorityHeaps.
    public enum ComparisonResult: Sendable, Hashable {
        /// Indicates that the first heap is the preferred one based on the comparison criteria.
        case first
        /// Indicates that second heap is the preferred one based on the comparison criteria.
        case second
    }
    
    /// Determines which heap contains the element with the lesser priority (minimum element).
    ///
    /// - Parameters:
    ///   - firstHeap: The first PriorityHeap to compare.
    ///   - secondHeap: The second PriorityHeap to compare.
    /// - Returns: A `ComparisonResult` indicating which heap's minimum element has a lesser priority,
    ///            or `nil` if both heaps are empty or their minimum elements have equal
    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public static func lesserHeap(_ first: Self, _ second: Self) -> ComparisonResult? {
        switch (first.min, second.min) {
        case (nil, nil): nil
        case (.some, nil): .first
        case (nil, .some): .second
        case (let firstMin?, let secondMin?):
            if firstMin.priority < secondMin.priority {
                .first
            } else if firstMin.priority > secondMin.priority {
                .second
            } else {
                nil
            }
        }
    }
    
    /// Determines which heap contains the element with the greater priority (maximum element).
    ///
    /// - Parameters:
    ///   - firstHeap: The first PriorityHeap to compare.
    ///   - secondHeap: The second PriorityHeap to compare.
    /// - Returns: A `ComparisonResult` indicating which heap's maximum element has a greater priority,
    ///            or `nil` if both heaps are empty or their maximum elements have equal
    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public static func greaterHeap(_ first: Self, _ second: Self) -> ComparisonResult? {
        switch (first.max, second.max) {
        case (nil, nil): nil
        case (.some, nil): .first
        case (nil, .some): .second
        case (let firstMax?, let secondMax?):
            if firstMax.priority > secondMax.priority {
                .first
            } else if firstMax.priority < secondMax.priority {
                .second
            } else {
                nil
            }
        }
    }
}

extension PriorityHeap {
    /// Access the heap with the lesser minimum element, or on a specified heap if both minimum elements are equal.
    ///
    /// - Parameters:
    ///   - first: The first heap to compare.
    ///   - second: The second heap to compare.
    ///   - default: The `ComparisonResult` to use if both heaps have minimum elements with equal priority.
    ///   - update: A closure that takes a `PriorityHeap` and returns a result of type `Result`.
    /// - Returns: The result of the `update` closure.
    public static func withLesserHeap<Result>(_ first: Self, _ second: Self, ifEqual default: ComparisonResult, access: (Self) throws -> Result) rethrows -> Result {
        var tempFirst = first
        var tempSecond = second
        return try withLesserHeap(&tempFirst, &tempSecond, ifEqual: `default`) { heap in
            try access(heap)
        }
    }
    
    /// Access the heap with the greater maximum element, or on a specified heap if both maximum elements are equal.
    ///
    /// - Parameters:
    ///   - first: The first heap to compare.
    ///   - second: The second heap to compare.
    ///   - default: The `ComparisonResult` to use if both heaps have maximum elements with equal priority.
    ///   - update: A closure that takes a `PriorityHeap` and returns a result of type `Result`.
    /// - Returns: The result of the `update` closure.
    public static func withGreaterHeap<Result>(_ first: Self, _ second: Self, ifEqual default: ComparisonResult, access: (Self) throws -> Result) rethrows -> Result {
        var tempFirst = first
        var tempSecond = second
        return try withGreaterHeap(&tempFirst, &tempSecond, ifEqual: `default`) { heap in
            try access(heap)
        }
    }

    /// Performs an operation on the heap with the lesser minimum element, or on a specified heap if both minimum elements are equal.
    ///
    /// This method allows you to perform an operation on the heap that has the lesser minimum element (i.e., the heap with the element of the lowest priority).
    /// If both heaps have minimum elements with equal priority, the operation is performed on the heap specified by the `default` parameter.
    ///
    /// - Parameters:
    ///   - first: The first heap to compare.
    ///   - second: The second heap to compare.
    ///   - default: The `ComparisonResult` to use if both heaps have minimum elements with equal priority.
    ///   - update: A closure that takes an inout reference to a `PriorityHeap` and returns a result of type `Result`.
    /// - Returns: The result of the `update` closure.
    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public static func withLesserHeap<Result>(_ first: inout Self, _ second: inout Self, ifEqual default: ComparisonResult, update: (inout Self) throws -> Result) rethrows -> Result {
        switch lesserHeap(first, second) ?? `default` {
        case .first: return try update(&first)
        case .second: return try update(&second)
        }
    }
    
    /// Performs an operation on the heap with the greater maximum element, or on a specified heap if both maximum elements are equal.
    ///
    /// This method allows you to perform an operation on the heap that has the greater maximum element (i.e., the heap with the element of the highest priority).
    /// If both heaps have maximum elements with equal priority, the operation is performed on the heap specified by the `default` parameter.
    ///
    /// - Parameters:
    ///   - first: The first heap to compare, passed by reference.
    ///   - second: The second heap to compare, passed by reference.
    ///   - default: The `ComparisonResult` to use if both heaps have maximum elements with equal priority.
    ///   - update: A closure that takes an inout reference to a `PriorityHeap` and returns a result of type `Result`.
    /// - Returns: The result of the `update` closure.
    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public static func withGreaterHeap<Result>(_ first: inout Self, _ second: inout Self, ifEqual default: ComparisonResult, update: (inout Self) throws -> Result) rethrows -> Result {
        switch greaterHeap(first, second) ?? `default` {
        case .first: return try update(&first)
        case .second: return try update(&second)
        }
    }
}


extension PriorityHeap {
    /// Returns the minimum element from the heap with the lesser minimum element priority.
    ///
    /// - Parameters:
    ///   - first: The first heap to compare.
    ///   - second: The second heap to compare.
    /// - Returns: The minimum element from the heap with the lesser minimum element priority.
    /// - Complexity: O(1)
    /// - Note: If both heaps have minimum elements with equal priority, the minimum element from the first heap is returned.
    @inlinable @inline(__always)
    public static func min(_ first: Self, _ second: Self) -> Element? {
        withLesserHeap(first, second, ifEqual: .first) { $0.min }
    }
    
    /// Returns the maximum element from the heap with the greater maximum element priority.
    ///
    /// - Parameters:
    ///   - first: The first heap to compare.
    ///   - second: The second heap to compare.
    /// - Returns: The maximum element from the heap with the greater maximum element priority.
    /// - Complexity: O(1)
    /// - Note: If both heaps have maximum elements with equal priority, the maximum element from the second heap is returned.
    @inlinable @inline(__always)
    public static func max(_ first: Self, _ second: Self) -> Element? {
        withGreaterHeap(first, second, ifEqual: .first) { $0.max }
    }
    
    /// Removes and returns the minimum element from the heap with the lesser minimum element priority.
    ///
    /// - Parameters:
    ///   - first: The first heap to compare.
    ///   - second: The second heap to compare.
    /// - Returns: The minimum element from the heap with the lesser minimum element priority.
    /// - Complexity: O(log(`count`)) element comparisons
    /// - Note: If both heaps have minimum elements with equal priority, the minimum element from the first heap is removed and returned.
    @inlinable @inline(__always)
    public static func popMin(_ first: inout Self, _ second: inout Self) -> Element? {
        withLesserHeap(&first, &second, ifEqual: .first) { $0.popMin() }
    }
    
    /// Removes and returns the maximum element from the heap with the greater maximum element priority.
    ///
    /// - Parameters:
    ///   - first: The first heap to compare.
    ///   - second: The second heap to compare.
    /// - Returns: The maximum element from the heap with the greater maximum element priority.
    /// - Complexity: O(log(`count`)) element comparisons
    /// - Note: If both heaps have maximum elements with equal priority, the maximum element from the second heap is removed and returned.
    @inlinable @inline(__always)
    public static func popMax(_ first: inout Self, _ second: inout Self) -> Element? {
        withGreaterHeap(&first, &second, ifEqual: .second) { $0.popMax() }
    }
    
    /// Removes the minimum element from the heap with the lesser minimum element priority.
    ///
    /// - Parameters:
    ///   - first: The first heap to compare.
    ///   - second: The second heap to compare.
    /// - Complexity: O(log(`count`)) element comparisons
    /// - Returns: The minimum element from the heap with the lesser minimum element priority.
    /// - Note: If both heaps have minimum elements with equal priority, the minimum element from the first heap is removed.
    @inlinable @inline(__always)
    public static func removeMin(_ first: inout Self, _ second: inout Self) -> Element {
        withLesserHeap(&first, &second, ifEqual: .first) { $0.removeMin() }
    }
    
    /// Removes the maximum element from the heap with the greater maximum element priority.
    ///
    /// - Parameters:
    ///   - first: The first heap to compare.
    ///   - second: The second heap to compare.
    /// - Complexity: O(log(`count`)) element comparisons
    /// - Returns: The maximum element from the heap with the greater maximum element priority.
    /// - Note: If both heaps have maximum elements with equal priority, the maximum element from the second heap is removed.
    @inlinable @inline(__always)
    public static func removeMax(_ first: inout Self, _ second: inout Self) -> Element {
        withGreaterHeap(&first, &second, ifEqual: .second) { $0.removeMax() }
    }
}
