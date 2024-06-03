import Algorithms
import Dependencies
import Foundation
import HealthKit

/// A utility for building activity streaks from a collection of activity summaries.
public struct ActivityStreakBuilder {

    /// Generates activity streaks from the provided activity summaries and the current date.
    ///
    /// - Parameters:
    ///   - summaries: An array of activity summaries.
    ///   - today: The current date.
    /// - Returns: An array of activity streaks.
    public static func streaks(from summaries: [ActivitySummary], today: Date) -> [ActivityStreak] {
        guard !summaries.isEmpty else { return [] }

        // Filter completed activity summaries
        var completedSummaries = summaries.filter(\.didComplete)

        @Dependency(\.calendar) var calendar

        // If the last summary is in the current day and its goal has not been met, append it so the summary still
        // counts. It's not considered incomplete until the end of the current day.
        if let lastSummary = summaries.last,
           !lastSummary.didComplete,
           calendar.isDate(lastSummary.date, inSameDayAs: today) {
            completedSummaries.append(lastSummary)
        }

        // Group completed summaries
        let chunkedSummaries = completedSummaries.chunked { lhs, rhs in
            let daysApart = calendar.dateComponents([.day], from: lhs.date, to: rhs.date).day ?? 0
            return daysApart == 1
        }

        let longEnoughStreaks = chunkedSummaries
        // Filter groups of summaries which have more than one day in the streak
            .filter { $0.count >= 1 }
        // Create `ActivityStreak`s
            .map { summaries in
                // Check to see if the last summary is considered completed (value >= goal). If not, remove it from the
                // streak so that the previous day is set as the end of the streak.
                var summariesCopy = summaries
                var isCurrent = false
                if let lastSummary = summariesCopy.last,
                   calendar.isDate(lastSummary.date, inSameDayAs: today) {
                    if !lastSummary.didComplete {
                        summariesCopy.removeLast()
                    }
                    isCurrent = true
                }
                return ActivityStreak(summaries: Array(summariesCopy), isCurrentStreak: isCurrent)
            }
        // Remove `nil` streaks
            .compactMap { $0 }

        return longEnoughStreaks
    }
}
