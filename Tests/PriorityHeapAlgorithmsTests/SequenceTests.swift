import XCTest
import PriorityHeapModule
import PriorityHeapAlgorithms

final class SequenceTests: XCTestCase {
    
    // MARK: Ascending Sequence
    
    func testAscendingSequence() {
        let heap: PriorityHeap = [3, 1, 2]
        let ascendingSequence = heap.ascending()
        XCTAssertEqual(Array(ascendingSequence), [1, 2, 3])
    }
    
    func testAscendingSequenceEmptyHeap() {
        let heap: PriorityHeap<Int> = []
        let ascendingSequence = heap.ascending()
        XCTAssertTrue(Array(ascendingSequence).isEmpty)
    }
    
    func testAscendingSequenceSingleElement() {
        let heap: PriorityHeap = [42]
        let ascendingSequence = heap.ascending()
        XCTAssertEqual(Array(ascendingSequence), [42])
    }
    
    // MARK: Descending Sequence
    
    func testDescendingSequence() {
        let heap: PriorityHeap = [3, 1, 2]
        let descendingSequence = heap.descending()
        XCTAssertEqual(Array(descendingSequence), [3, 2, 1])
    }
    
    func testDescendingSequenceEmptyHeap() {
        let heap: PriorityHeap<Int> = []
        let descendingSequence = heap.descending()
        XCTAssertTrue(Array(descendingSequence).isEmpty)
    }
    
    func testDescendingSequenceSingleElement() {
        let heap: PriorityHeap = [42]
        let descendingSequence = heap.descending()
        XCTAssertEqual(Array(descendingSequence), [42])
    }
}
