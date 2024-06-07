import Dependencies
import HealthKit
import Models
import XCTest

internal final class ActivityStreaksBuilderTests: XCTestCase {

    // MARK: Exercise

    internal func test_returnsEmptyStreaksExercise_whenSummariesEmpty() {
        withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.date.now) var now
            XCTAssertTrue(ActivityStreaksBuilder.exerciseStreaks(from: [], today: now).isEmpty)
        }
    }
    
    internal func test_returnsPopulatedStreaksExercise_whenSummariesNotEmpty() throws {
        withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.date.now) var now
            let summary1 = HKActivitySummary()
            summary1.appleExerciseTime = .init(unit: .minute(), doubleValue: 1)
            summary1.exerciseTimeGoal = .init(unit: .minute(), doubleValue: 1)
            let summary2 = HKActivitySummary()
            summary2.appleExerciseTime = .init(unit: .minute(), doubleValue: 1)
            summary2.exerciseTimeGoal = .init(unit: .minute(), doubleValue: 1)
            let streaks = ActivityStreaksBuilder.exerciseStreaks(from: [summary1, summary2], today: now)
            XCTAssertEqual(streaks.count, 2)
        }
    }

    // MARK: Move

    internal func test_returnsEmptyStreaksMove_whenSummariesEmpty() throws {
        withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.date.now) var now
            XCTAssertTrue(ActivityStreaksBuilder.moveStreaks(from: [], today: now).isEmpty)
        }
    }
    
    internal func test_returnsPopulatedStreaksMove_whenSummariesNotEmpty() throws {
        withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.date.now) var now
            let summary1 = HKActivitySummary()
            summary1.activeEnergyBurned = .init(unit: .kilocalorie(), doubleValue: 1)
            summary1.activeEnergyBurnedGoal = .init(unit: .kilocalorie(), doubleValue: 1)
            let summary2 = HKActivitySummary()
            summary2.activeEnergyBurned = .init(unit: .kilocalorie(), doubleValue: 1)
            summary2.activeEnergyBurnedGoal = .init(unit: .kilocalorie(), doubleValue: 1)
            let streaks = ActivityStreaksBuilder.moveStreaks(from: [summary1, summary2], today: now)
            XCTAssertEqual(streaks.count, 2)
        }
    }

    // MARK: Stand

    internal func test_returnsEmptyStreaksStand_whenSummariesEmpty() throws {
        withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.date.now) var now
            XCTAssertTrue(ActivityStreaksBuilder.standStreaks(from: [], today: now).isEmpty)
        }
    }

    internal func test_returnsPopulatedStreaksStand_whenSummariesNotEmpty() throws {
        withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.date.now) var now
            let summary1 = HKActivitySummary()
            summary1.appleStandHours = .init(unit: .count(), doubleValue: 1)
            summary1.standHoursGoal = .init(unit: .count(), doubleValue: 1)
            let summary2 = HKActivitySummary()
            summary2.appleStandHours = .init(unit: .count(), doubleValue: 1)
            summary2.standHoursGoal = .init(unit: .count(), doubleValue: 1)
            let streaks = ActivityStreaksBuilder.standStreaks(from: [summary1, summary2], today: now)
            XCTAssertEqual(streaks.count, 2)
        }
    }

    // MARK: Streaks

    internal func test_returnsEmptyStreaks_whenSummariesEmpty() {
        withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.date.now) var now
            let streaks = ActivityStreaksBuilder.streaks(for: [.exercise], summaries: [], today: now)
            XCTAssertTrue(streaks.exercise.isEmpty)
            XCTAssertTrue(streaks.move.isEmpty)
            XCTAssertTrue(streaks.stand.isEmpty)
        }
    }

    internal func test_returnsNonEmptyStreaks_whenSummariesNotEmpty() {
        withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.date.now) var now

            let exerciseSummary = HKActivitySummary()
            exerciseSummary.appleExerciseTime = .init(unit: .minute(), doubleValue: 1)
            exerciseSummary.exerciseTimeGoal = .init(unit: .minute(), doubleValue: 1)

            let moveSummary = HKActivitySummary()
            moveSummary.activeEnergyBurned = .init(unit: .kilocalorie(), doubleValue: 1)
            moveSummary.activeEnergyBurnedGoal = .init(unit: .kilocalorie(), doubleValue: 1)

            let standSummary = HKActivitySummary()
            standSummary.appleStandHours = .init(unit: .count(), doubleValue: 1)
            standSummary.standHoursGoal = .init(unit: .count(), doubleValue: 1)
            
            let streaks = ActivityStreaksBuilder.streaks(
                for: [.exercise, .move, .stand],
                summaries: [exerciseSummary, moveSummary, standSummary],
                today: now
            )
            XCTAssertEqual(streaks.exercise.count, 1)
            XCTAssertEqual(streaks.move.count, 1)
            XCTAssertEqual(streaks.stand.count, 1)
        }
    }

    internal func test_returnsStreaksWithExercise_whenActivityStreaksOptionsExercise() {
        withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.date.now) var now

            let exerciseSummary = HKActivitySummary()
            exerciseSummary.appleExerciseTime = .init(unit: .minute(), doubleValue: 1)
            exerciseSummary.exerciseTimeGoal = .init(unit: .minute(), doubleValue: 1)

            let moveSummary = HKActivitySummary()
            moveSummary.activeEnergyBurned = .init(unit: .kilocalorie(), doubleValue: 1)
            moveSummary.activeEnergyBurnedGoal = .init(unit: .kilocalorie(), doubleValue: 1)

            let standSummary = HKActivitySummary()
            standSummary.appleStandHours = .init(unit: .count(), doubleValue: 1)
            standSummary.standHoursGoal = .init(unit: .count(), doubleValue: 1)
            
            let streaks = ActivityStreaksBuilder.streaks(
                for: .exercise,
                summaries: [exerciseSummary, moveSummary, standSummary],
                today: now
            )
            XCTAssertEqual(streaks.exercise.count, 1)
            XCTAssertTrue(streaks.move.isEmpty)
            XCTAssertTrue(streaks.stand.isEmpty)
        }
    }

    internal func test_returnsStreaksWithMove_whenActivityStreaksOptionsMove() {
        withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.date.now) var now

            let exerciseSummary = HKActivitySummary()
            exerciseSummary.appleExerciseTime = .init(unit: .minute(), doubleValue: 1)
            exerciseSummary.exerciseTimeGoal = .init(unit: .minute(), doubleValue: 1)

            let moveSummary = HKActivitySummary()
            moveSummary.activeEnergyBurned = .init(unit: .kilocalorie(), doubleValue: 1)
            moveSummary.activeEnergyBurnedGoal = .init(unit: .kilocalorie(), doubleValue: 1)

            let standSummary = HKActivitySummary()
            standSummary.appleStandHours = .init(unit: .count(), doubleValue: 1)
            standSummary.standHoursGoal = .init(unit: .count(), doubleValue: 1)
            
            let streaks = ActivityStreaksBuilder.streaks(
                for: .move,
                summaries: [exerciseSummary, moveSummary, standSummary],
                today: now
            )
            XCTAssertTrue(streaks.exercise.isEmpty)
            XCTAssertEqual(streaks.move.count, 1)
            XCTAssertTrue(streaks.stand.isEmpty)
        }
    }

    internal func test_returnsStreaksWithStand_whenActivityStreaksOptionsStand() {
        withDependencies { dependencies in
            dependencies.calendar = .current
            dependencies.date = .constant(.now)
        } operation: {
            @Dependency(\.date.now) var now

            let exerciseSummary = HKActivitySummary()
            exerciseSummary.appleExerciseTime = .init(unit: .minute(), doubleValue: 1)
            exerciseSummary.exerciseTimeGoal = .init(unit: .minute(), doubleValue: 1)

            let moveSummary = HKActivitySummary()
            moveSummary.activeEnergyBurned = .init(unit: .kilocalorie(), doubleValue: 1)
            moveSummary.activeEnergyBurnedGoal = .init(unit: .kilocalorie(), doubleValue: 1)

            let standSummary = HKActivitySummary()
            standSummary.appleStandHours = .init(unit: .count(), doubleValue: 1)
            standSummary.standHoursGoal = .init(unit: .count(), doubleValue: 1)
            
            let streaks = ActivityStreaksBuilder.streaks(
                for: .stand,
                summaries: [exerciseSummary, moveSummary, standSummary],
                today: now
            )
            XCTAssertTrue(streaks.exercise.isEmpty)
            XCTAssertTrue(streaks.move.isEmpty)
            XCTAssertEqual(streaks.stand.count, 1)
        }
    }
}
