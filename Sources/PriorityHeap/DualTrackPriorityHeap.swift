/// A dual-track priority heap structure that manages two separate priority heaps.
///
/// This structure maintains two priority heaps: one for "bare" elements and one for "flagged" elements.
/// It allows for efficient tracking and manipulation of elements based on their priority and flagged status.
public struct DualTrackPriorityHeap<Element: Prioritizable> {
    /// The primary heap that stores the unflagged elements.
    ///
    /// This heap contains the elements that are not currently flagged. Operations on this heap
    /// affect only the unflagged elements.
    public var bare: PriorityHeap<Element> = []
    
    /// The secondary heap that stores the flagged elements.
    ///
    /// This heap contains the elements that have been flagged. Operations on this heap
    /// affect only the flagged elements. Flagged elements can be thought of as having a special status
    /// that may require separate handling or prioritization.
    public var flagged: PriorityHeap<Element> = []
    
    /// Initializes a new empty `DualTrackPriorityHeap`.
    ///
    /// Both the bare and flagged heaps are initialized as empty priority heaps.
    public init() {}
}

/// Conformance to the `Sendable` protocol for `DualTrackPriorityHeap` where `Element` is `Sendable`.
extension DualTrackPriorityHeap: Sendable where Element: Sendable {}

extension DualTrackPriorityHeap {
    /// Inserts the given element into the heap.
    ///
    /// - Parameter flagged: If true, element is inserted into the flagged track of the heap.
    ///   Otherwise, element is inserted into the bare track.
    ///
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    public mutating func insert(_ element: Element, flagged: Bool) {
        if flagged {
            self.flagged.insert(element)
        } else {
            bare.insert(element)
        }
    }
    
    /// Inserts the given element into the heap.
    ///
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    public mutating func insert(_ element: Element) {
        bare.insert(element)
    }
}

extension DualTrackPriorityHeap {
    /// A Boolean value indicating whether or not the heap is empty.
    ///
    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public var isEmpty: Bool {
        bare.isEmpty && flagged.isEmpty
    }
    
    /// The number of elements in the heap.
    ///
    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public var count: Int {
        bare.count + flagged.count
    }
}
    
extension DualTrackPriorityHeap {
    public struct UnorderedView: RandomAccessCollection {
        public typealias Base = PriorityHeap<Element>.UnorderedView
        
        public var bare: Base
        public var flagged: Base

        @usableFromInline
        internal init(bare: Base, flagged: Base) {
            self.bare = bare
            self.flagged = flagged
        }

        public enum Index: Comparable {
            case bare(Base.Index)
            case flagged(Base.Index)
        }
        
        @inlinable @inline(__always)
        public var startIndex: Index {
            .bare(bare.startIndex)
        }

        @inlinable @inline(__always)
        public var endIndex: Index {
            .flagged(flagged.endIndex)
        }

        @inlinable
        public func index(before i: Index) -> Index {
            switch i {
            case .bare(let index): 
                .bare(bare.index(before: index))
            case .flagged(flagged.startIndex):
                .bare(bare.index(before: bare.endIndex))
            case .flagged(let index):
                .flagged(flagged.index(before: index))
            }
        }

        @inlinable
        public func index(after i: Index) -> Index {
            switch i {
            case .bare(bare.index(before: bare.endIndex)):
                .flagged(flagged.startIndex)
            case .bare(let index):
                .bare(bare.index(after: index))
            case .flagged(let index):
                .flagged(flagged.index(after: index))
            }
        }

        @inlinable @inline(__always)
        public subscript(position: Index) -> Element {
            switch position {
            case .bare(let index): bare[index]
            case .flagged(let index): flagged[index]
            }
        }
    }
    
    /// A read-only view into the underlying array.
    ///
    /// Note: The elements aren't _arbitrarily_ ordered (it is, after all, a
    /// heap). However, no guarantees are given as to the ordering of the elements
    /// or that this won't change in future versions of the library.
    ///
    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public var unordered: UnorderedView {
        .init(bare: bare.unordered, flagged: flagged.unordered)
    }
}
    
extension DualTrackPriorityHeap {
    /// Determines if the minimum element is in the flagged heap.
    ///
    /// - Returns: A Boolean value indicating whether the minimum element is in the flagged heap.
    @inlinable @inline(__always)
    var flaggedMin: Bool {
        switch (bare.min(), flagged.min()) {
        case (nil, nil): return false
        case (nil, .some): return true
        case (.some, nil): return false
        case (let bareMin?, let flaggedMin?): return bareMin.priority >= flaggedMin.priority
        }
    }
    
    /// Determines if the maximum element is in the flagged heap.
    ///
    /// - Returns: A Boolean value indicating whether the maximum element is in the flagged heap.
    @inlinable @inline(__always)
    var flaggedMax: Bool {
        switch (bare.max(), flagged.max()) {
        case (nil, nil): return false
        case (nil, .some): return true
        case (.some, nil): return false
        case (let bareMax?, let flaggedMax?): return bareMax.priority <= flaggedMax.priority
        }
    }
    
    /// Returns the element with the lowest priority, if available.
    ///
    /// - Returns: The element with the lowest priority or `nil` if the heap is empty.
    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public func min() -> Element? {
        flaggedMin ? flagged.min() : bare.min()
    }
    
    /// Returns the element with the highest priority, if available.
    ///
    /// - Returns: The element with the highest priority or `nil` if the heap is empty.
    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public func max() -> Element? {
        flaggedMax ? flagged.max() : bare.max()
    }
    
    /// Removes and returns the element with the lowest priority, if available.
    ///
    /// - Returns: The element with the lowest priority or `nil` if the heap is empty.
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    public mutating func popMin() -> Element? {
        flaggedMin ? flagged.popMin() : bare.popMin()
    }
    
    /// Removes and returns the element with the highest priority, if available.
    ///
    /// - Returns: The element with the highest priority or `nil` if the heap is empty.
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    public mutating func popMax() -> Element? {
        flaggedMax ? flagged.popMax() : bare.popMax()
    }
    
    /// Removes and returns the element with the lowest priority.
    ///
    /// The heap *must not* be empty when calling this method.
    ///
    /// - Returns: The element with the lowest priority.
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    public mutating func removeMin() -> Element {
        flaggedMin ? flagged.removeMin() : bare.removeMin()
    }
    
    /// Removes and returns the element with the highest priority.
    ///
    /// The heap *must not* be empty when calling this method.
    ///
    /// - Returns: The element with the highest priority.
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    public mutating func removeMax() -> Element {
        flaggedMax ? flagged.removeMax() : bare.removeMax()
    }
    
    /// Flags the minimum element from the bare heap by moving it to the flagged heap.
    ///
    /// - Returns: The element that was moved to the flagged heap, or `nil` if the bare heap was empty.
    public mutating func flagMinBare() -> Element? {
        guard let element = bare.popMin() else { return nil }
        flagged.insert(element)
        return element
    }
    
    /// Flags the maximum element from the bare heap by moving it to the flagged heap.
    ///
    /// - Returns: The element that was moved to the flagged heap, or `nil` if the bare heap was empty.
    public mutating func flagMaxBare() -> Element? {
        guard let element = bare.popMax() else { return nil }
        flagged.insert(element)
        return element
    }
    
    /// Unflags the minimum element from the flagged heap by moving it back to the bare heap.
    ///
    /// - Returns: The element that was moved back to the bare heap, or `nil` if the flagged heap was empty.
    public mutating func unflagMinFlagged() -> Element? {
        guard let element = flagged.popMin() else { return nil }
        bare.insert(element)
        return element
    }
    
    /// Unflags the maximum element from the flagged heap by moving it back to the bare heap.
    ///
    /// - Returns: The element that was moved back to the bare heap, or `nil` if the flagged heap was empty.
    public mutating func unflagMaxFlagged() -> Element? {
        guard let element = flagged.popMax() else { return nil }
        bare.insert(element)
        return element
    }
}

// MARK: -

extension DualTrackPriorityHeap {
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

extension DualTrackPriorityHeap: CustomStringConvertible {
  /// A textual representation of this instance.
  public var description: String {
      "DualTrackPriorityHeap(bare: \(bare), flagged: \(flagged))"
  }
}

extension DualTrackPriorityHeap: CustomDebugStringConvertible {
  /// A textual representation of this instance, suitable for debugging.
  public var debugDescription: String {
      description
  }
}
