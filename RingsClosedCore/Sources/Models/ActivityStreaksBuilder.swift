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

     /// Generates activity streaks from HealthKit activity summaries.
     /// - Parameters:
     ///   - summaries: An array of `HKActivitySummary` objects.
     ///   - today: The current date.
     /// - Returns: An `ActivityStreaks` object containing streaks for exercise, move, and stand activities.
    public static func streaks(from summaries: [HKActivitySummary], today: Date) -> ActivityStreaks {
        ActivityStreaks(
            exercise: exerciseStreaks(from: summaries, today: today),
            move: moveStreaks(from: summaries, today: today),
            stand: standStreaks(from: summaries, today: today)
        )
    }
}
