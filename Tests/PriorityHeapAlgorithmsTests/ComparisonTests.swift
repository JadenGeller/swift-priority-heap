import XCTest
import PriorityHeapModule
import PriorityHeapAlgorithms

final class ComparisonTests: XCTestCase {
    
    // MARK: lesserHeap
    
    func testLesserHeapFirstHeapEmpty() {
        assertHeapsUnchanged([], [1, 2, 3]) { emptyHeap, nonEmptyHeap in
            XCTAssertEqual(PriorityHeap.lesserHeap(emptyHeap, nonEmptyHeap), .second)
        }
    }

    func testLesserHeapSecondHeapEmpty() {
        assertHeapsUnchanged([1, 2, 3], []) { nonEmptyHeap, emptyHeap in
            XCTAssertEqual(PriorityHeap.lesserHeap(nonEmptyHeap, emptyHeap), .first)
        }
    }

    func testLesserHeapFirstHeapHasLesserMinimumElement() {
        assertHeapsUnchanged([1, 2, 3], [4, 5, 6]) { heapWithLesserMin, heapWithGreaterMin in
            XCTAssertEqual(PriorityHeap.lesserHeap(heapWithLesserMin, heapWithGreaterMin), .first)
        }
    }

    func testLesserHeapSecondHeapHasLesserMinimumElement() {
        assertHeapsUnchanged([4, 5, 6], [1, 2, 3]) { heapWithGreaterMin, heapWithLesserMin in
            XCTAssertEqual(PriorityHeap.lesserHeap(heapWithGreaterMin, heapWithLesserMin), .second)
        }
    }

    func testLesserHeapEqualMinimumElements() {
        assertHeapsUnchanged([3, 4, 5], [3, 6, 7]) { heapWithEqualMin1, heapWithEqualMin2 in
            XCTAssertNil(PriorityHeap.lesserHeap(heapWithEqualMin1, heapWithEqualMin2))
        }
    }
    
    // MARK: greaterHeap
    
    func testGreaterHeapBothHeapsEmpty() {
        assertHeapsUnchanged([], [] as PriorityHeap<Int>) { emptyHeap1, emptyHeap2 in
            XCTAssertNil(PriorityHeap.greaterHeap(emptyHeap1, emptyHeap2))
        }
    }

    func testGreaterHeapFirstHeapEmpty() {
        assertHeapsUnchanged([], [1, 2, 3]) { emptyHeap, nonEmptyHeap in
            XCTAssertEqual(PriorityHeap.greaterHeap(emptyHeap, nonEmptyHeap), .second)
        }
    }

    func testGreaterHeapSecondHeapEmpty() {
        assertHeapsUnchanged([1, 2, 3], []) { nonEmptyHeap, emptyHeap in
            XCTAssertEqual(PriorityHeap.greaterHeap(nonEmptyHeap, emptyHeap), .first)
        }
    }

    func testGreaterHeapFirstHeapHasGreaterMaximumElement() {
        assertHeapsUnchanged([4, 5, 6], [1, 2, 3]) { heapWithGreaterMax, heapWithLesserMax in
            XCTAssertEqual(PriorityHeap.greaterHeap(heapWithGreaterMax, heapWithLesserMax), .first)
        }
    }

    func testGreaterHeapSecondHeapHasGreaterMaximumElement() {
        assertHeapsUnchanged([1, 2, 3], [4, 5, 6]) { heapWithLesserMax, heapWithGreaterMax in
            XCTAssertEqual(PriorityHeap.greaterHeap(heapWithLesserMax, heapWithGreaterMax), .second)
        }
    }

    func testGreaterHeapEqualMaximumElements() {
        assertHeapsUnchanged([3, 4, 7], [4, 6, 7]) { heapWithEqualMax1, heapWithEqualMax2 in
            XCTAssertNil(PriorityHeap.greaterHeap(heapWithEqualMax1, heapWithEqualMax2))
        }
    }
    
    // MARK: min
    
    func testMinBothHeapsEmpty() {
        assertHeapsUnchanged([], [] as PriorityHeap<Int>) { emptyHeap1, emptyHeap2 in
            XCTAssertNil(PriorityHeap.min(emptyHeap1, emptyHeap2))
        }
    }

    func testMinFirstHeapEmpty() {
        assertHeapsUnchanged([], [1, 2, 3]) { emptyHeap, nonEmptyHeap in
            XCTAssertEqual(PriorityHeap.min(emptyHeap, nonEmptyHeap), 1)
        }
    }

    func testMinSecondHeapEmpty() {
        assertHeapsUnchanged([1, 2, 3], []) { nonEmptyHeap, emptyHeap in
            XCTAssertEqual(PriorityHeap.min(nonEmptyHeap, emptyHeap), 1)
        }
    }

    func testMinFirstHeapHasLesserMinimumElement() {
        assertHeapsUnchanged([1, 2, 3], [4, 5, 6]) { heapWithLesserMin, heapWithGreaterMin in
            XCTAssertEqual(PriorityHeap.min(heapWithLesserMin, heapWithGreaterMin), 1)
        }
    }

    func testMinSecondHeapHasLesserMinimumElement() {
        assertHeapsUnchanged([4, 5, 6], [1, 2, 3]) { heapWithGreaterMin, heapWithLesserMin in
            XCTAssertEqual(PriorityHeap.min(heapWithGreaterMin, heapWithLesserMin), 1)
        }
    }

    func testMinEqualMinimumElements() {
        assertHeapsUnchanged([3, 4, 5], [3, 6, 7]) { heapWithEqualMin1, heapWithEqualMin2 in
            XCTAssertEqual(PriorityHeap.min(heapWithEqualMin1, heapWithEqualMin2), 3)
        }
    }
    
    // MARK: max
    
    func testMaxBothHeapsEmpty() {
        assertHeapsUnchanged([], [] as PriorityHeap<Int>) { emptyHeap1, emptyHeap2 in
            XCTAssertNil(PriorityHeap.max(emptyHeap1, emptyHeap2))
        }
    }

    func testMaxFirstHeapEmpty() {
        assertHeapsUnchanged([], [1, 2, 3]) { emptyHeap, nonEmptyHeap in
            XCTAssertEqual(PriorityHeap.max(emptyHeap, nonEmptyHeap), 3)
        }
    }

    func testMaxSecondHeapEmpty() {
        assertHeapsUnchanged([1, 2, 3], []) { nonEmptyHeap, emptyHeap in
            XCTAssertEqual(PriorityHeap.max(nonEmptyHeap, emptyHeap), 3)
        }
    }

    func testMaxFirstHeapHasGreaterMaximumElement() {
        assertHeapsUnchanged([4, 5, 6], [1, 2, 3]) { heapWithGreaterMax, heapWithLesserMax in
            XCTAssertEqual(PriorityHeap.max(heapWithGreaterMax, heapWithLesserMax), 6)
        }
    }

    func testMaxSecondHeapHasGreaterMaximumElement() {
        assertHeapsUnchanged([1, 2, 3], [4, 5, 6]) { heapWithLesserMax, heapWithGreaterMax in
            XCTAssertEqual(PriorityHeap.max(heapWithLesserMax, heapWithGreaterMax), 6)
        }
    }

    func testMaxEqualMaximumElements() {
        assertHeapsUnchanged([3, 4, 5], [3, 5, 7]) { heapWithEqualMax1, heapWithEqualMax2 in
            XCTAssertEqual(PriorityHeap.max(heapWithEqualMax1, heapWithEqualMax2), 7)
        }
    }

    // MARK: popMin

    func testPopMinBothHeapsEmpty() {
        var emptyHeap1: PriorityHeap<Int> = []
        var emptyHeap2: PriorityHeap<Int> = []
        
        XCTAssertNil(PriorityHeap.popMin(&emptyHeap1, &emptyHeap2))
        assertHeapEquals(emptyHeap1, [])
        assertHeapEquals(emptyHeap2, [])
    }

    func testPopMinFirstHeapEmpty() {
        var emptyHeap: PriorityHeap<Int> = []
        var nonEmptyHeap: PriorityHeap<Int> = [1, 2, 3]
        
        XCTAssertEqual(PriorityHeap.popMin(&emptyHeap, &nonEmptyHeap), 1)
        assertHeapEquals(emptyHeap, [])
        assertHeapEquals(nonEmptyHeap, [2, 3])
    }

    func testPopMinSecondHeapEmpty() {
        var nonEmptyHeap: PriorityHeap<Int> = [1, 2, 3]
        var emptyHeap: PriorityHeap<Int> = []
        
        XCTAssertEqual(PriorityHeap.popMin(&nonEmptyHeap, &emptyHeap), 1)
        assertHeapEquals(nonEmptyHeap, [2, 3])
        assertHeapEquals(emptyHeap, [])
    }

    func testPopMinFirstHeapHasLesserMinimumElement() {
        var heap1: PriorityHeap<Int> = [1, 2, 3]
        var heap2: PriorityHeap<Int> = [4, 5, 6]
        
        XCTAssertEqual(PriorityHeap.popMin(&heap1, &heap2), 1)
        assertHeapEquals(heap1, [2, 3])
        assertHeapEquals(heap2, [4, 5, 6])
    }

    func testPopMinSecondHeapHasLesserMinimumElement() {
        var heap1: PriorityHeap<Int> = [4, 5, 6]
        var heap2: PriorityHeap<Int> = [1, 2, 3]
        
        XCTAssertEqual(PriorityHeap.popMin(&heap1, &heap2), 1)
        assertHeapEquals(heap1, [4, 5, 6])
        assertHeapEquals(heap2, [2, 3])
    }

    func testPopMinEqualMinimumElements() {
        var heap1: PriorityHeap<Int> = [3, 4, 5]
        var heap2: PriorityHeap<Int> = [3, 6, 7]
        
        XCTAssertEqual(PriorityHeap.popMin(&heap1, &heap2), 3)
        assertHeapEquals(heap1, [4, 5])
        assertHeapEquals(heap2, [3, 6, 7])
    }

    // MARK: popMax

    func testPopMaxBothHeapsEmpty() {
        var emptyHeap1: PriorityHeap<Int> = []
        var emptyHeap2: PriorityHeap<Int> = []
        
        XCTAssertNil(PriorityHeap.popMax(&emptyHeap1, &emptyHeap2))
        assertHeapEquals(emptyHeap1, [])
        assertHeapEquals(emptyHeap2, [])
    }

    func testPopMaxFirstHeapEmpty() {
        var emptyHeap: PriorityHeap<Int> = []
        var nonEmptyHeap: PriorityHeap<Int> = [1, 2, 3]
        
        XCTAssertEqual(PriorityHeap.popMax(&emptyHeap, &nonEmptyHeap), 3)
        assertHeapEquals(emptyHeap, [])
        assertHeapEquals(nonEmptyHeap, [1, 2])
    }

    func testPopMaxSecondHeapEmpty() {
        var nonEmptyHeap: PriorityHeap<Int> = [1, 2, 3]
        var emptyHeap: PriorityHeap<Int> = []
        
        XCTAssertEqual(PriorityHeap.popMax(&nonEmptyHeap, &emptyHeap), 3)
        assertHeapEquals(nonEmptyHeap, [1, 2])
        assertHeapEquals(emptyHeap, [])
    }

    func testPopMaxFirstHeapHasGreaterMaximumElement() {
        var heap1: PriorityHeap<Int> = [4, 5, 6]
        var heap2: PriorityHeap<Int> = [1, 2, 3]
        
        XCTAssertEqual(PriorityHeap.popMax(&heap1, &heap2), 6)
        assertHeapEquals(heap1, [4, 5])
        assertHeapEquals(heap2, [1, 2, 3])
    }

    func testPopMaxSecondHeapHasGreaterMaximumElement() {
        var heap1: PriorityHeap<Int> = [1, 2, 3]
        var heap2: PriorityHeap<Int> = [4, 5, 6]
        
        XCTAssertEqual(PriorityHeap.popMax(&heap1, &heap2), 6)
        assertHeapEquals(heap1, [1, 2, 3])
        assertHeapEquals(heap2, [4, 5])
    }

    func testPopMaxEqualMaximumElements() {
        var heap1: PriorityHeap<Int> = [3, 4, 7]
        var heap2: PriorityHeap<Int> = [3, 5, 7]
        
        XCTAssertEqual(PriorityHeap.popMax(&heap1, &heap2), 7)
        assertHeapEquals(heap1, [3, 4, 7])
        assertHeapEquals(heap2, [3, 5])
    }

    // MARK: removeMin

    func testRemoveMinFirstHeapHasLesserMinimumElement() {
        var heap1: PriorityHeap<Int> = [1, 2, 3]
        var heap2: PriorityHeap<Int> = [4, 5, 6]
        
        XCTAssertEqual(PriorityHeap.removeMin(&heap1, &heap2), 1)
        assertHeapEquals(heap1, [2, 3])
        assertHeapEquals(heap2, [4, 5, 6])
    }

    func testRemoveMinSecondHeapHasLesserMinimumElement() {
        var heap1: PriorityHeap<Int> = [4, 5, 6]
        var heap2: PriorityHeap<Int> = [1, 2, 3]
        
        XCTAssertEqual(PriorityHeap.removeMin(&heap1, &heap2), 1)
        assertHeapEquals(heap1, [4, 5, 6])
        assertHeapEquals(heap2, [2, 3])
    }

    // MARK: removeMax

    func testRemoveMaxFirstHeapHasGreaterMaximumElement() {
        var heap1: PriorityHeap<Int> = [4, 5, 6]
        var heap2: PriorityHeap<Int> = [1, 2, 3]
        
        XCTAssertEqual(PriorityHeap.removeMax(&heap1, &heap2), 6)
        assertHeapEquals(heap1, [4, 5])
        assertHeapEquals(heap2, [1, 2, 3])
    }

    func testRemoveMaxSecondHeapHasGreaterMaximumElement() {
        var heap1: PriorityHeap<Int> = [1, 2, 3]
        var heap2: PriorityHeap<Int> = [4, 5, 6]
        
        XCTAssertEqual(PriorityHeap.removeMax(&heap1, &heap2), 6)
        assertHeapEquals(heap1, [1, 2, 3])
        assertHeapEquals(heap2, [4, 5])
    }
}
