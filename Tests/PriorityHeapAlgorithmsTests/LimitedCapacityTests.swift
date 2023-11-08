import XCTest
import PriorityHeapModule
import PriorityHeapAlgorithms

final class PriorityHeapTests: XCTestCase {
    
    // MARK: attemptInsert
    
    func testInsertBelowCapacity() {
        var heap: PriorityHeap = [3, 1, 2]
        XCTAssertEqual(heap.attemptInsert(4, capacity: 5, evictionPolicy: .evictMin), .fit)
        assertHeapEquals(heap, [1, 2, 3, 4])
    }
    
    func testInsertAtCapacityEvictMax() {
        var heap: PriorityHeap = [1, 2, 3]
        XCTAssertEqual(heap.attemptInsert(0, capacity: 3, evictionPolicy: .evictMax), .evict(3))
        assertHeapEquals(heap, [0, 1, 2])
    }
    
    func testInsertAtCapacityEvictMin() {
        var heap: PriorityHeap = [1, 2, 3]
        XCTAssertEqual(heap.attemptInsert(4, capacity: 3, evictionPolicy: .evictMin), .evict(1))
        assertHeapEquals(heap, [2, 3, 4])
    }
    
    func testInsertIntoEmptyHeap() {
        var heap: PriorityHeap<Int> = []
        XCTAssertEqual(heap.attemptInsert(1, capacity: 1, evictionPolicy: .evictMin), .fit)
        assertHeapEquals(heap, [1])
    }
    
    func testInsertWithZeroCapacity() {
        var heap: PriorityHeap<Int> = []
        XCTAssertEqual(heap.attemptInsert(4, capacity: 0, evictionPolicy: .evictMin), .reject)
        assertHeapEquals(heap, [])
    }
    
    func testInsertIdenticalPriorityElements() {
        var heap: PriorityHeap = [2, 2, 2]
        XCTAssertEqual(heap.attemptInsert(2, capacity: 4, evictionPolicy: .evictMin), .fit)
        assertHeapEquals(heap, [2, 2, 2, 2])
    }
    
    func testInsertAtCapacityWithIdenticalPriorityElementsRejects() {
        var heap: PriorityHeap = [2, 2, 2]
        XCTAssertEqual(heap.attemptInsert(2, capacity: 3, evictionPolicy: .evictMax), .reject)
        assertHeapEquals(heap, [2, 2, 2])
    }
    
    // MARK: evictExcess
    
    func testEvictFromBelowCapacity() {
        var heap: PriorityHeap = [1, 2, 3]
        heap.evictExcess(capacity: 4, evictionPolicy: .evictMax)
        assertHeapEquals(heap, [1, 2, 3])
    }
    
    func testEvictFromAtCapacity() {
        var heap: PriorityHeap = [1, 2, 3]
        heap.evictExcess(capacity: 3, evictionPolicy: .evictMax)
        assertHeapEquals(heap, [1, 2, 3])
    }
    
    func testEvictFromAboveCapacityEvictMax() {
        var heap: PriorityHeap = [1, 2, 3, 4, 5]
        heap.evictExcess(capacity: 3, evictionPolicy: .evictMax)
        assertHeapEquals(heap, [1, 2, 3])
    }
    
    func testEvictFromAboveCapacityEvictMin() {
        var heap: PriorityHeap = [1, 2, 3, 4, 5]
        heap.evictExcess(capacity: 3, evictionPolicy: .evictMin)
        assertHeapEquals(heap, [3, 4, 5])
    }
    
    func testEvictFromEmptyHeap() {
        var heap: PriorityHeap<Int> = []
        heap.evictExcess(capacity: 1, evictionPolicy: .evictMax)
        assertHeapEquals(heap, [])
    }
    
    func testEvictWithZeroCapacity() {
        var heap: PriorityHeap = [1, 2, 3]
        heap.evictExcess(capacity: 0, evictionPolicy: .evictMax)
        assertHeapEquals(heap, [])
    }
    
    func testEvictIdenticalPriorityElements() {
        var heap: PriorityHeap = [2, 2, 2, 2]
        heap.evictExcess(capacity: 2, evictionPolicy: .evictMin)
        assertHeapEquals(heap, [2, 2])
    }
}
