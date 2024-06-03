import Dependencies
import Foundation
import HealthKit
import Models
import XCTest

internal final class ActivitySummariesBuilderTests: XCTestCase {

    // MARK: Exercise

    internal func test_exerciseSummariesReturnsEmptyArray_whenProvidedSummariesEmpty() {
        XCTAssertTrue(ActivitySummariesBuilder.exerciseSummaries(from: []).isEmpty)
    }

    internal func test_exerciseSummariesReturnsNonEmptyArray_whenProvidedSummariesNotEmpty() {
        withDependencies { dependencies in
            dependencies.calendar = .current
        } operation: {
            let summary = HKActivitySummary()
            summary.appleExerciseTime = .init(unit: .minute(), doubleValue: 1)
            summary.exerciseTimeGoal = .init(unit: .minute(), doubleValue: 1)
            let summaries = [summary]
            XCTAssertEqual(ActivitySummariesBuilder.exerciseSummaries(from: summaries).count, 1)
        }
    }

    // MARK: Move

    internal func test_moveSummariesReturnsEmptyArray_whenProvidedSummariesEmpty() {
        XCTAssertTrue(ActivitySummariesBuilder.moveSummaries(from: []).isEmpty)
    }

    internal func test_moveSummariesReturnsNonEmptyArray_whenProvidedSummariesNotEmpty() {
        withDependencies { dependencies in
            dependencies.calendar = .current
        } operation: {
            let summary = HKActivitySummary()
            summary.activeEnergyBurned = .init(unit: .kilocalorie(), doubleValue: 1)
            summary.activeEnergyBurnedGoal = .init(unit: .kilocalorie(), doubleValue: 1)
            let summaries = [summary]
            XCTAssertEqual(ActivitySummariesBuilder.moveSummaries(from: summaries).count, 1)
        }
    }

    // MARK: Stand

    internal func test_standSummariesReturnsEmptyArray_whenProvidedSummariesEmpty() {
        XCTAssertTrue(ActivitySummariesBuilder.standSummaries(from: []).isEmpty)
    }

    internal func test_standSummariesReturnsNonEmptyArray_whenProvidedSummariesNotEmpty() {
        withDependencies { dependencies in
            dependencies.calendar = .current
        } operation: {
            let summary = HKActivitySummary()
            summary.appleStandHours = .init(unit: .count(), doubleValue: 1)
            summary.standHoursGoal = .init(unit: .count(), doubleValue: 1)
            let summaries = [summary]
            XCTAssertEqual(ActivitySummariesBuilder.standSummaries(from: summaries).count, 1)
        }
    }
}
