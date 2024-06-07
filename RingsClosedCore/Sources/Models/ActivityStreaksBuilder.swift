import Dependencies
import Foundation
import HealthKit


/// A utility for generating activity streaks based on HealthKit activity summaries.
public struct ActivityStreaksBuilder {

     /// Generates exercise streaks from HealthKit activity summaries.
     /// - Parameters:
     ///   - summaries: An array of `HKActivitySummary` objects.
     ///   - today: The current date.
     /// - Returns: An array of `ActivityStreak` objects representing exercise streaks.
    public static func exerciseStreaks(from summaries: [HKActivitySummary], today: Date) -> [ActivityStreak] {
        let exerciseSummaries = ActivitySummariesBuilder.exerciseSummaries(from: summaries)
        let streaks = ActivityStreakBuilder.streaks(from: exerciseSummaries, today: today)
        return streaks
    }

     /// Generates move streaks from HealthKit activity summaries.
     /// - Parameters:
     ///   - summaries: An array of `HKActivitySummary` objects.
     ///   - today: The current date.
     /// - Returns: An array of `ActivityStreak` objects representing move streaks.
    public static func moveStreaks(from summaries: [HKActivitySummary], today: Date) -> [ActivityStreak] {
        let moveSummaries = ActivitySummariesBuilder.moveSummaries(from: summaries)
        let streaks = ActivityStreakBuilder.streaks(from: moveSummaries, today: today)
        return streaks
    }

     /// Generates stand streaks from HealthKit activity summaries.
     /// - Parameters:
     ///   - summaries: An array of `HKActivitySummary` objects.
     ///   - today: The current date.
     /// - Returns: An array of `ActivityStreak` objects representing stand streaks.
    public static func standStreaks(from summaries: [HKActivitySummary], today: Date) -> [ActivityStreak] {
        let standSummaries = ActivitySummariesBuilder.standSummaries(from: summaries)
        let streaks = ActivityStreakBuilder.streaks(from: standSummaries, today: today)
        return streaks
    }

    /**
     Calculates activity streaks based on the specified options and activity summaries.

     This method computes streaks for the activities specified in the given options, considering the provided activity summaries and the current date.

     - Parameters:
     - streaks: The options indicating which activity streaks to calculate.
     - summaries: An array of health kit activity summaries to compute streaks from.
     - today: The current date used for calculating streaks.

     - Returns: An `ActivityStreaks` object containing streaks for the specified activities.

     - Precondition: The `streaks` parameter must not be empty.

     Example usage:
     ```swift
     let options: ActivityStreaksOptions = [.exercise, .move]
     let streaks = ActivityStreaksManager.streaks(for: options, summaries: activitySummaries, today: Date())
     print("Exercise streaks: \(streaks.exercise)")
     print("Move streaks: \(streaks.move)")
     print("Stand streaks: \(streaks.stand)")
     ```

     Note: This method retrieves streaks for exercise, movement, and standing activities based on the provided options and summaries.

     Warning: Ensure that the streaks parameter is not empty to avoid assertion failures.

     */
    public static func streaks(
        for streaks: ActivityStreaksOptions,
        summaries: [HKActivitySummary],
        today: Date
    ) -> ActivityStreaks {
        assert(!streaks.isEmpty)
        // Calculate streaks for each activity based on the provided options
        let exerciseStreaks = streaks.contains(.exercise) ? exerciseStreaks(from: summaries, today: today) : []
        let moveStreaks = streaks.contains(.move) ? moveStreaks(from: summaries, today: today) : []
        let standStreaks = streaks.contains(.stand) ? standStreaks(from: summaries, today: today) : []

        // Return an ActivityStreaks object containing calculated streaks
        return ActivityStreaks(
            exercise: exerciseStreaks,
            move: moveStreaks,
            stand: standStreaks
        )
    }
}
