import Dependencies
import Foundation
import HealthKit

/// A utility for building activity summaries from HealthKit activity summaries.
public struct ActivitySummaryBuilder {

    /// Generates an activity summary for exercise from the provided HealthKit activity summary.
    ///
    /// - Parameter summary: The HealthKit activity summary.
    /// - Returns: An activity summary for exercise, or `nil` if the required data is not available.
    public static func exerciseSummary(from summary: HKActivitySummary) -> ActivitySummary? {
        @Dependency(\.calendar) var calendar
        guard let summaryDate = calendar.date(from: summary.dateComponents(for: calendar)),
              let goal = summary.exerciseTimeGoal?.doubleValue(for: .minute()),
              goal > 0
        else { return nil }

        let value = summary.appleExerciseTime.doubleValue(for: .minute())
        return ActivitySummary(date: summaryDate, didComplete: value >= goal)
    }

    /// Generates an activity summary for movement from the provided HealthKit activity summary.
    ///
    /// - Parameter summary: The HealthKit activity summary.
    /// - Returns: An activity summary for movement, or `nil` if the required data is not available.
    public static func moveSummary(from summary: HKActivitySummary) -> ActivitySummary? {
        @Dependency(\.calendar) var calendar
        guard let summaryDate = calendar.date(from: summary.dateComponents(for: calendar)) else { return nil }

        let goal = summary.activeEnergyBurnedGoal.doubleValue(for: .kilocalorie())
        guard goal > 0 else { return nil }
        let value = summary.activeEnergyBurned.doubleValue(for: .kilocalorie())
        return ActivitySummary(date: summaryDate, didComplete: value >= goal)
    }

    /// Generates an activity summary for standing from the provided HealthKit activity summary.
    ///
    /// - Parameter summary: The HealthKit activity summary.
    /// - Returns: An activity summary for standing, or `nil` if the required data is not available.
    public static func standSummary(from summary: HKActivitySummary) -> ActivitySummary? {
        @Dependency(\.calendar) var calendar
        guard let summaryDate = calendar.date(from: summary.dateComponents(for: calendar)),
              let goal = summary.standHoursGoal?.doubleValue(for: .count()),
              goal > 0
        else { return nil }

        let value = summary.appleStandHours.doubleValue(for: .count())
        return ActivitySummary(date: summaryDate, didComplete: value >= goal)
    }
}
