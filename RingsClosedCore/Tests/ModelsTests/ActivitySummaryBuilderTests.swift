import Dependencies
import Foundation
import HealthKit
import Models
import XCTest

internal final class ActivitySummaryBuilderTests: XCTestCase {

    // MARK: Exercise

    internal func test_ReturnsNonNilActivitySummaryExercise_withGoalMet() throws {
        try withDependencies { dependencies in
            dependencies.calendar = .current
        } operation: {
            @Dependency(\.calendar) var calendar
            let summary = HKActivitySummary()
            summary.appleExerciseTime = .init(unit: .minute(), doubleValue: 1)
            summary.exerciseTimeGoal = .init(unit: .minute(), doubleValue: 1)
            let activitySummary = try XCTUnwrap(
                ActivitySummaryBuilder.exerciseSummary(from: summary)
            )

            // The summary date cannot be created, so the following date was created by asserting the expected date against `.distantPast` and then copying the date string from the test failure.
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let summaryDate = try XCTUnwrap(dateFormatter.date(from: "0001-01-01 04:56:02 +0000"))

            let expectedActivitySummary = ActivitySummary(date: summaryDate, didComplete: true)
            XCTAssertEqual(activitySummary, expectedActivitySummary)
        }
    }

    internal func test_ReturnsNonNilActivitySummaryExercise_withGoalNotMet() throws {
        try withDependencies { dependencies in
            dependencies.calendar = .current
        } operation: {
            @Dependency(\.calendar) var calendar
            let summary = HKActivitySummary()
            summary.appleExerciseTime = .init(unit: .minute(), doubleValue: 0)
            summary.exerciseTimeGoal = .init(unit: .minute(), doubleValue: 1)
            let activitySummary = try XCTUnwrap(
                ActivitySummaryBuilder.exerciseSummary(from: summary)
            )

            // The summary date cannot be created, so the following date was created by asserting the expected date against `.distantPast` and then copying the date string from the test failure.
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let summaryDate = try XCTUnwrap(dateFormatter.date(from: "0001-01-01 04:56:02 +0000"))

            let expectedActivitySummary = ActivitySummary(date: summaryDate, didComplete: false)
            XCTAssertEqual(activitySummary, expectedActivitySummary)
        }
    }

    internal func test_ReturnsNilActivitySummaryExercise_whenGoalIsNil() {
        withDependencies { dependencies in
            dependencies.calendar = .current
        } operation: {
            let summary = HKActivitySummary()
            summary.appleExerciseTime = .init(unit: .minute(), doubleValue: 1)
            summary.exerciseTimeGoal = nil
            XCTAssertNil(ActivitySummaryBuilder.exerciseSummary(from: summary))
        }
    }

    // MARK: Move

    internal func test_ReturnsNonNilActivitySummaryMove_withGoalMet() throws {
        try withDependencies { dependencies in
            dependencies.calendar = .current
        } operation: {
            @Dependency(\.calendar) var calendar
            let summary = HKActivitySummary()
            summary.activeEnergyBurned = .init(unit: .kilocalorie(), doubleValue: 1)
            summary.activeEnergyBurnedGoal = .init(unit: .kilocalorie(), doubleValue: 1)
            let activitySummary = try XCTUnwrap(
                ActivitySummaryBuilder.moveSummary(from: summary)
            )

            // The summary date cannot be created, so the following date was created by asserting the expected date against `.distantPast` and then copying the date string from the test failure.
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let summaryDate = try XCTUnwrap(dateFormatter.date(from: "0001-01-01 04:56:02 +0000"))

            let expectedActivitySummary = ActivitySummary(date: summaryDate, didComplete: true)
            XCTAssertEqual(activitySummary, expectedActivitySummary)
        }
    }

    internal func test_ReturnsNonNilActivitySummaryMove_withGoalNotMet() throws {
        try withDependencies { dependencies in
            dependencies.calendar = .current
        } operation: {
            @Dependency(\.calendar) var calendar
            let summary = HKActivitySummary()
            summary.activeEnergyBurned = .init(unit: .kilocalorie(), doubleValue: 0)
            summary.activeEnergyBurnedGoal = .init(unit: .kilocalorie(), doubleValue: 1)
            let activitySummary = try XCTUnwrap(
                ActivitySummaryBuilder.moveSummary(from: summary)
            )

            // The summary date cannot be created, so the following date was created by asserting the expected date against `.distantPast` and then copying the date string from the test failure.
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let summaryDate = try XCTUnwrap(dateFormatter.date(from: "0001-01-01 04:56:02 +0000"))

            let expectedActivitySummary = ActivitySummary(date: summaryDate, didComplete: false)
            XCTAssertEqual(activitySummary, expectedActivitySummary)
        }
    }

    // MARK: Stand

    internal func test_ReturnsNonNilActivitySummaryStand_withGoalMet() throws {
        try withDependencies { dependencies in
            dependencies.calendar = .current
        } operation: {
            @Dependency(\.calendar) var calendar
            let summary = HKActivitySummary()
            summary.appleStandHours = .init(unit: .count(), doubleValue: 1)
            summary.standHoursGoal = .init(unit: .count(), doubleValue: 1)
            let activitySummary = try XCTUnwrap(
                ActivitySummaryBuilder.standSummary(from: summary)
            )

            // The summary date cannot be created, so the following date was created by asserting the expected date against `.distantPast` and then copying the date string from the test failure.
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let summaryDate = try XCTUnwrap(dateFormatter.date(from: "0001-01-01 04:56:02 +0000"))

            let expectedActivitySummary = ActivitySummary(date: summaryDate, didComplete: true)
            XCTAssertEqual(activitySummary, expectedActivitySummary)
        }
    }

    internal func test_ReturnsNonNilActivitySummaryStand_withGoalNotMet() throws {
        try withDependencies { dependencies in
            dependencies.calendar = .current
        } operation: {
            @Dependency(\.calendar) var calendar
            let summary = HKActivitySummary()
            summary.appleStandHours = .init(unit: .count(), doubleValue: 0)
            summary.standHoursGoal = .init(unit: .count(), doubleValue: 1)
            let activitySummary = try XCTUnwrap(
                ActivitySummaryBuilder.standSummary(from: summary)
            )

            // The summary date cannot be created, so the following date was created by asserting the expected date against `.distantPast` and then copying the date string from the test failure.
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let summaryDate = try XCTUnwrap(dateFormatter.date(from: "0001-01-01 04:56:02 +0000"))

            let expectedActivitySummary = ActivitySummary(date: summaryDate, didComplete: false)
            XCTAssertEqual(activitySummary, expectedActivitySummary)
        }
    }

    internal func test_ReturnsNilActivitySummaryStand_whenGoalIsNil() {
        withDependencies { dependencies in
            dependencies.calendar = .current
        } operation: {
            let summary = HKActivitySummary()
            summary.appleStandHours = .init(unit: .count(), doubleValue: 1)
            summary.standHoursGoal = nil
            XCTAssertNil(ActivitySummaryBuilder.exerciseSummary(from: summary))
        }
    }
}
