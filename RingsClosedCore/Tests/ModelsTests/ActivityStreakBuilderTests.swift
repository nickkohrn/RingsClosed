import Dependencies
import Foundation
import Models
import XCTest

internal final class ActivityStreakBuilderTests: XCTestCase {
    
    internal func test_returnsEmptyStreaks_whenSummariesEmpty() {
        let streaks = ActivityStreakBuilder.streaks(from: [], today: .now)
        XCTAssertTrue(streaks.isEmpty)
    }

    internal func test_returnsArrayOfOneStreak_whenContiguousSummariesAreComplete() throws {
        try withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.calendar) var calendar
            @Dependency(\.date) var date
            let date1 = try XCTUnwrap(calendar.date(from: DateComponents(year: 2024, month: 1, day: 1)))
            let summary1 = try XCTUnwrap(ActivitySummary(date: date1, didComplete: true))
            let date2 = try XCTUnwrap(calendar.date(from: DateComponents(year: 2024, month: 1, day: 2)))
            let summary2 = try XCTUnwrap(ActivitySummary(date: date2, didComplete: true))
            let date3 = try XCTUnwrap(calendar.date(from: DateComponents(year: 2024, month: 1, day: 3)))
            let summary3 = try XCTUnwrap(ActivitySummary(date: date3, didComplete: true))
            let streaks = ActivityStreakBuilder.streaks(from: [summary1, summary2, summary3], today: date.now)
            XCTAssertEqual(streaks.count, 1)
            let streak = try XCTUnwrap(streaks.first)
            XCTAssertEqual(streak.startDate, calendar.date(from: DateComponents(year: 2024, month: 1, day: 1)))
            XCTAssertEqual(streak.endDate, calendar.date(from: DateComponents(year: 2024, month: 1, day: 3)))
            XCTAssertEqual(streak.isCurrentStreak, false)
            XCTAssertEqual(streak.summaries, [summary1, summary2, summary3])
        }
    }

    internal func test_returnsArrayOfMultipleStreaks_whenStreaksAreNotContiguous() throws {
        try withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.calendar) var calendar
            @Dependency(\.date) var date
            let date1 = try XCTUnwrap(calendar.date(from: DateComponents(year: 2024, month: 1, day: 1)))
            let summary1 = try XCTUnwrap(ActivitySummary(date: date1, didComplete: true))
            let date2 = try XCTUnwrap(calendar.date(from: DateComponents(year: 2024, month: 1, day: 2)))
            let summary2 = try XCTUnwrap(ActivitySummary(date: date2, didComplete: true))
            let date3 = try XCTUnwrap(calendar.date(from: DateComponents(year: 2024, month: 1, day: 6)))
            let summary3 = try XCTUnwrap(ActivitySummary(date: date3, didComplete: true))
            let date4 = try XCTUnwrap(calendar.date(from: DateComponents(year: 2024, month: 1, day: 7)))
            let summary4 = try XCTUnwrap(ActivitySummary(date: date4, didComplete: true))
            let streaks = ActivityStreakBuilder.streaks(from: [summary1, summary2, summary3, summary4], today: date.now)
            XCTAssertEqual(streaks.count, 2)
            let streak1 = try XCTUnwrap(streaks.first)
            XCTAssertEqual(streak1.startDate, calendar.date(from: DateComponents(year: 2024, month: 1, day: 1)))
            XCTAssertEqual(streak1.endDate, calendar.date(from: DateComponents(year: 2024, month: 1, day: 2)))
            XCTAssertEqual(streak1.isCurrentStreak, false)
            XCTAssertEqual(streak1.summaries, [summary1, summary2])
            let streak2 = try XCTUnwrap(streaks.last)
            XCTAssertEqual(streak2.startDate, calendar.date(from: DateComponents(year: 2024, month: 1, day: 6)))
            XCTAssertEqual(streak2.endDate, calendar.date(from: DateComponents(year: 2024, month: 1, day: 7)))
            XCTAssertEqual(streak2.isCurrentStreak, false)
            XCTAssertEqual(streak2.summaries, [summary3, summary4])
        }
    }

    internal func test_calculatesIsCurrentStreak_whenStreakContainsCurrentDay() throws {
        try withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 3))))
        } operation: {
            @Dependency(\.calendar) var calendar
            @Dependency(\.date) var date
            let date1 = try XCTUnwrap(calendar.date(from: DateComponents(year: 2024, month: 1, day: 1)))
            let summary1 = try XCTUnwrap(ActivitySummary(date: date1, didComplete: true))
            let date2 = try XCTUnwrap(calendar.date(from: DateComponents(year: 2024, month: 1, day: 2)))
            let summary2 = try XCTUnwrap(ActivitySummary(date: date2, didComplete: true))
            let date3 = try XCTUnwrap(calendar.date(from: DateComponents(year: 2024, month: 1, day: 3)))
            let summary3 = try XCTUnwrap(ActivitySummary(date: date3, didComplete: false))
            let streaks = ActivityStreakBuilder.streaks(from: [summary1, summary2, summary3], today: date.now)
            let streak = try XCTUnwrap(streaks.first)
            XCTAssertEqual(streak.isCurrentStreak, true)
        }
    }
}
