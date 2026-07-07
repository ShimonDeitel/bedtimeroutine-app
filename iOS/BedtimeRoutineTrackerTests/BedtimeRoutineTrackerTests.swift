import XCTest
@testable import BedtimeRoutineTracker

@MainActor
final class BedtimeRoutineTrackerTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
        store.save()
    }

    func testAddItem() {
        let item = RoutineStep(title: "Test", note: "Note")
        store.add(item)
        XCTAssertEqual(store.items.count, 1)
    }

    func testAddInsertsAtFront() {
        store.add(RoutineStep(title: "First", note: ""))
        store.add(RoutineStep(title: "Second", note: ""))
        XCTAssertEqual(store.items.first?.title, "Second")
    }

    func testDeleteItem() {
        let item = RoutineStep(title: "ToDelete", note: "")
        store.add(item)
        store.delete(item)
        XCTAssertTrue(store.items.isEmpty)
    }

    func testDeleteAtOffsets() {
        store.add(RoutineStep(title: "A", note: ""))
        store.add(RoutineStep(title: "B", note: ""))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
    }

    func testFreeLimitAllowsAdding() {
        for i in 0..<Store.freeLimit {
            store.add(RoutineStep(title: "Item \(i)", note: ""))
        }
        XCTAssertEqual(store.items.count, Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenUnderLimit() {
        store.add(RoutineStep(title: "One", note: ""))
        XCTAssertTrue(store.canAddMore)
    }

    func testProBypassesLimit() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(RoutineStep(title: "Item \(i)", note: ""))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateItem() {
        var item = RoutineStep(title: "Original", note: "")
        store.add(item)
        item.title = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first?.title, "Updated")
    }
}
