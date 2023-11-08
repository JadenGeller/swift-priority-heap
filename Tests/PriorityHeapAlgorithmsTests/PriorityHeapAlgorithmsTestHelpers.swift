import XCTest
@testable import PriorityHeapModule

func assertHeapEquals<T: Comparable>(_ heap: PriorityHeap<T>, _ expectedElements: [T], file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(heap.unordered.sorted(), expectedElements, file: file, line: line)
}

func assertHeapEquals<T: Comparable>(_ first: PriorityHeap<T>, _ second: PriorityHeap<T>, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(first.unordered.sorted(), second.unordered.sorted(), file: file, line: line)
}

func assertHeapsUnchanged<T: Comparable>(
    _ first: PriorityHeap<T>,
    _ second: PriorityHeap<T>,
    operation: (inout PriorityHeap<T>, inout PriorityHeap<T>) -> Void,
    file: StaticString = #file,
    line: UInt = #line
) {
    var mutableFirst = first
    var mutableSecond = second
    operation(&mutableFirst, &mutableSecond)
    assertHeapEquals(first, mutableFirst, file: file, line: line)
    assertHeapEquals(second, mutableSecond, file: file, line: line)
}

extension Int: Prioritizable {
    public var priority: Int { self }
}
