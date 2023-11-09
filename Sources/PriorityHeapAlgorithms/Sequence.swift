import PriorityHeapModule

/// A sequence that provides elements in ascending order based on their priority.
public struct AscendingSequence<Element: Prioritizable>: Sequence {
    @usableFromInline
    internal var heap: PriorityHeap<Element>
    
    @inlinable @inline(__always)
    internal init(heap: PriorityHeap<Element>) {
        self.heap = heap
    }
    
    /// An iterator that returns elements of the sequence in ascending order.
    public struct Iterator: IteratorProtocol {
        @usableFromInline
        internal var heap: PriorityHeap<Element>
        
        @inlinable @inline(__always)
        internal init(heap: PriorityHeap<Element>) {
            self.heap = heap
        }
        
        @inlinable @inline(__always)
        public mutating func next() -> Element? {
            heap.popMin()
        }
    }
    
    /// Creates an iterator that will return the elements in ascending order.
    @inlinable @inline(__always)
    public func makeIterator() -> Iterator {
        .init(heap: heap)
    }
}

/// A sequence that provides elements in descending order based on their priority.
public struct DescendingSequence<Element: Prioritizable>: Sequence {
    @usableFromInline
    internal var heap: PriorityHeap<Element>
    
    @inlinable @inline(__always)
    internal init(heap: PriorityHeap<Element>) {
        self.heap = heap
    }
    
    /// An iterator that returns elements of the sequence in descending order.
    public struct Iterator: IteratorProtocol {
        @usableFromInline
        internal var heap: PriorityHeap<Element>
        
        @inlinable @inline(__always)
        internal init(heap: PriorityHeap<Element>) {
            self.heap = heap
        }
        
        /// Returns the next element in the sequence, or `nil` if no more elements are available.
        @inlinable @inline(__always)
        public mutating func next() -> Element? {
            heap.popMax()
        }
    }
    
    /// Creates an iterator that will return the elements in descending order.
    @inlinable @inline(__always)
    public func makeIterator() -> Iterator {
        .init(heap: heap)
    }
}

extension PriorityHeap {
    /// Returns a sequence of the heap's elements in ascending order.
    @inlinable @inline(__always)
    public func ascending() -> AscendingSequence<Element> {
        .init(heap: self)
    }
    
    /// Returns a sequence of the heap's elements in descending order.
    @inlinable @inline(__always)
    public func descending() -> DescendingSequence<Element> {
        .init(heap: self)
    }
}
