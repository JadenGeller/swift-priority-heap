import HeapModule

@usableFromInline
internal struct PriorityItem<Referent: Prioritizable>: Comparable {
    @usableFromInline
    var referent: Referent
    
    @usableFromInline
    init(referent: Referent) {
        self.referent = referent
    }
    
    @usableFromInline
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.referent.priority == rhs.referent.priority
    }
    
    @usableFromInline
    static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.referent.priority < rhs.referent.priority
    }
}

extension PriorityItem: Sendable where Referent: Sendable {}

/// A [Min-Max Heap](https://en.wikipedia.org/wiki/Min-max_heap) data structure,
/// where the ordering is based on the priority of an element.
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
/// - Note: `PriorityHeap` is a specialized version of the `Heap` data structure from the swift-collections package.
///   It leverages the Prioritizable protocol to order elements based on their priority, which is a property of the elements.
///   This is particularly useful when the elements themselves are not directly comparable,
///   or when you want to order the elements based on a specific property.
public struct PriorityHeap<Element: Prioritizable> {
    @usableFromInline
    internal var _storage: Heap<PriorityItem<Element>> = []
}

extension PriorityHeap: Sendable where Element: Sendable {}

extension PriorityHeap {
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
}
      
extension PriorityHeap {
    public struct UnorderedView: RandomAccessCollection {
        @usableFromInline
        internal var base: [PriorityItem<Element>]

        @usableFromInline
        internal init(_ base: [PriorityItem<Element>]) {
            self.base = base
        }

        @inlinable @inline(__always)
        public var startIndex: Int {
            base.startIndex
        }

        @inlinable @inline(__always)
        public var endIndex: Int {
            base.endIndex
        }

        @inlinable @inline(__always)
        public func index(before i: Int) -> Int {
            base.index(before: i)
        }

        @inlinable @inline(__always)
        public func index(after i: Int) -> Int {
            base.index(after: i)
        }

        @inlinable @inline(__always)
        public subscript(position: Int) -> Element {
            base[position].referent
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
        .init(_storage.unordered)
    }
}

extension PriorityHeap {
    
    /// Inserts the given element into the heap.
    ///
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    public mutating func insert(_ element: Element) {
        _storage.insert(.init(referent: element))
    }
    
    /// Returns the element with the lowest priority, if available.
    ///
    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public func min() -> Element? {
        _storage.min()?.referent
    }
    
    /// Returns the element with the highest priority, if available.
    ///
    /// - Complexity: O(1)
    @inlinable @inline(__always)
    public func max() -> Element? {
        _storage.max()?.referent
    }
    
    /// Removes and returns the element with the lowest priority, if available.
    ///
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    public mutating func popMin() -> Element? {
        _storage.popMin()?.referent
    }
    
    /// Removes and returns the element with the highest priority, if available.
    ///
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    public mutating func popMax() -> Element? {
        _storage.popMax()?.referent
    }
    
    /// Removes and returns the element with the lowest priority.
    ///
    /// The heap *must not* be empty.
    ///
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    public mutating func removeMin() -> Element {
        _storage.removeMin().referent
    }
    
    /// Removes and returns the element with the highest priority.
    ///
    /// The heap *must not* be empty.
    ///
    /// - Complexity: O(log(`count`)) element comparisons
    @inlinable @inline(__always)
    public mutating func removeMax() -> Element {
        _storage.removeMax().referent
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
        _storage.replaceMin(with: .init(referent: replacement)).referent
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
        _storage.replaceMax(with: .init(referent: replacement)).referent
    }
}

// MARK: -

extension PriorityHeap {
    /// Initializes a heap from a sequence.
    ///
    /// - Complexity: O(*n*), where *n* is the number of items in `elements`.
    @inlinable @inline(__always)
    public init<S: Sequence>(_ elements: S) where S.Element == Element {
        _storage = .init(elements.lazy.map(PriorityItem.init))
    }
    
    /// Inserts the elements in the given sequence into the heap.
    ///
    /// - Parameter newElements: The new elements to insert into the heap.
    ///
    /// - Complexity: O(*n* * log(`count`)), where *n* is the length of `newElements`.
    @inlinable @inline(__always)
    public mutating func insert<S: Sequence>(
        contentsOf newElements: S
    ) where S.Element == Element {
        _storage.insert(contentsOf: newElements.lazy.map(PriorityItem.init))
    }
}

extension PriorityHeap: CustomStringConvertible {
  /// A textual representation of this instance.
  public var description: String {
      "Priority\(_storage.description)"
  }
}

extension PriorityHeap: CustomDebugStringConvertible {
  /// A textual representation of this instance, suitable for debugging.
  public var debugDescription: String {
      description
  }
}

extension PriorityHeap: ExpressibleByArrayLiteral {
  /// Creates a new heap from the contents of an array literal.
  ///
  /// **Do not call this initializer directly.** It is used by the compiler when
  /// you use an array literal. Instead, create a new heap using an array
  /// literal as its value by enclosing a comma-separated list of values in
  /// square brackets. You can use an array literal anywhere a heap is expected
  /// by the type context.
  ///
  /// - Parameter elements: A variadic list of elements of the new heap.
  public init(arrayLiteral elements: Element...) {
    self.init(elements)
  }
}
