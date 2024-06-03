import Dependencies
import Models
import XCTest

internal final class ActivityStreakTests: XCTestCase {

    internal func test_initFails_whenSummariesEmpty() {
        let streak = ActivityStreak(summaries: [])
        XCTAssertNil(streak)
    }

    internal func test_initSucceeds_whenSummariesContainsOne() throws {
        try withDependencies { dependencies in
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.date) var date
            let summary = try XCTUnwrap(ActivitySummary(
                date: date.now,
                didComplete: true
            ))
            _ = try XCTUnwrap(ActivityStreak(summaries: [summary]))
        }
    }

    internal func test_initSucceeds_whenSummariesContainsMultiple() throws {
        try withDependencies { dependencies in
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.date) var date
            let summary = try XCTUnwrap(ActivitySummary(
                date: date.now,
                didComplete: true
            ))
            _ = try XCTUnwrap(ActivityStreak(summaries: [summary, summary]))
        }
    }
}
