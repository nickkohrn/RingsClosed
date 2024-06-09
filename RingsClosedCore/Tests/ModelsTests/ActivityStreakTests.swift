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

    internal func test_streakDateRangeFormat_returnsFormattedString_whenStreakIsOneDay() throws {
        let currentDate = try XCTUnwrap(
            Calendar.current.date(from: DateComponents(
                year: 2024,
                month: 5,
                day: 6
            ))
        )
        try withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(currentDate)
        } operation: {
            @Dependency(\.date.now) var date
            let summary = try XCTUnwrap(ActivitySummary(
                date: date,
                didComplete: true
            ))
            let streak = try XCTUnwrap(ActivityStreak(summaries: [summary]))
            let formatted = streak.formatted(.streakDateRange)
            XCTAssertEqual(formatted, "May 6, 2024")
        }
    }

    internal func test_streakDateRangeFormat_returnsFormattedString_whenStreakIsMultipleDays() throws {
        let startDate = try XCTUnwrap(
            Calendar.current.date(from: DateComponents(
                year: 2024,
                month: 5,
                day: 6
            ))
        )
        let endDate = try XCTUnwrap(
            Calendar.current.date(from: DateComponents(
                year: 2024,
                month: 5,
                day: 7
            ))
        )
        try withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.date.now) var date
            let summary1 = try XCTUnwrap(ActivitySummary(
                date: startDate,
                didComplete: true
            ))
            let summary2 = try XCTUnwrap(ActivitySummary(
                date: endDate,
                didComplete: true
            ))
            let streak = try XCTUnwrap(ActivityStreak(summaries: [summary1, summary2]))
            let formatted = streak.formatted(.streakDateRange)
            XCTAssertEqual(formatted, "May 6 – 7, 2024")
        }
    }

    internal func test_streakDurationFormat_returnsFormattedString_whenStreakIsOneDay() throws {
        let currentDate = try XCTUnwrap(
            Calendar.current.date(from: DateComponents(
                year: 2024,
                month: 5,
                day: 6
            ))
        )
        try withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(currentDate)
        } operation: {
            @Dependency(\.date.now) var date
            let summary = try XCTUnwrap(ActivitySummary(
                date: date,
                didComplete: true
            ))
            let streak = try XCTUnwrap(ActivityStreak(summaries: [summary]))
            let formatted = streak.formatted(.streakDuration)
            XCTAssertEqual(formatted, "1 day")
        }
    }

    internal func test_streakDurationFormat_returnsFormattedString_whenStreakIsMultipleDays() throws {
        let startDate = try XCTUnwrap(
            Calendar.current.date(from: DateComponents(
                year: 2024,
                month: 5,
                day: 6
            ))
        )
        let endDate = try XCTUnwrap(
            Calendar.current.date(from: DateComponents(
                year: 2024,
                month: 5,
                day: 7
            ))
        )
        try withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.date.now) var date
            let summary1 = try XCTUnwrap(ActivitySummary(
                date: startDate,
                didComplete: true
            ))
            let summary2 = try XCTUnwrap(ActivitySummary(
                date: endDate,
                didComplete: true
            ))
            let streak = try XCTUnwrap(ActivityStreak(summaries: [summary1, summary2]))
            let formatted = streak.formatted(.streakDuration)
            XCTAssertEqual(formatted, "2 days")
        }
    }
}
