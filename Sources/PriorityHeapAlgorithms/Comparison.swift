import PriorityHeapModule

extension PriorityHeap {
    /// Represents the outcome of comparing two elements from PriorityHeaps.
    public enum ComparisonResult: Sendable, Hashable {
        /// Indicates that the element from the first heap is the preferred one based on the comparison criteria.
        case first
        /// Indicates that the element from the second heap is the preferred one based on the comparison criteria.
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
        switch (first.min(), second.min()) {
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
        switch (first.max(), second.max()) {
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
        switch lesserHeap(first, second) {
        case .first, nil: first.min()
        case .second: second.min()
        }
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
        switch greaterHeap(first, second) {
        case .first: first.max()
        case .second, nil: second.max()
        }
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
        switch lesserHeap(first, second) {
        case .first, nil: first.popMin()
        case .second: second.popMin()
        }
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
        switch greaterHeap(first, second) {
        case .first: first.popMax()
        case .second, nil: second.popMax()
        }
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
        switch lesserHeap(first, second) {
        case .first: first.removeMin()
        case .second, nil: second.removeMin()
        }
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
        switch greaterHeap(first, second) {
        case .first: first.removeMax()
        case .second, nil: second.removeMax()
        }
    }
}
