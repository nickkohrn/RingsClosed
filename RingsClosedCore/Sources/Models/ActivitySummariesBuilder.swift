import Dependencies
import Foundation
import HealthKit

/// A utility for building activity summaries from arrays of HealthKit activity summaries.
public struct ActivitySummariesBuilder {

    /// Generates activity summaries for exercise from the provided array of HealthKit activity summaries.
    ///
    /// - Parameter summaries: An array of HealthKit activity summaries.
    /// - Returns: An array of activity summaries for exercise.
    public static func exerciseSummaries(from summaries: [HKActivitySummary]) -> [ActivitySummary] {
        summaries.compactMap { summary in
            ActivitySummaryBuilder.exerciseSummary(from: summary)
        }
    }

    /// Generates activity summaries for movement from the provided array of HealthKit activity summaries.
    ///
    /// - Parameter summaries: An array of HealthKit activity summaries.
    /// - Returns: An array of activity summaries for movement.
    public static func moveSummaries(from summaries: [HKActivitySummary]) -> [ActivitySummary] {
        summaries.compactMap { summary in
            ActivitySummaryBuilder.moveSummary(from: summary)
        }
    }

    /// Generates activity summaries for standing from the provided array of HealthKit activity summaries.
    ///
    /// - Parameter summaries: An array of HealthKit activity summaries.
    /// - Returns: An array of activity summaries for standing.
    public static func standSummaries(from summaries: [HKActivitySummary]) -> [ActivitySummary] {
        summaries.compactMap { summary in
            ActivitySummaryBuilder.standSummary(from: summary)
        }
    }
}
