import Foundation

/// Represents a streak of activity, defined by a start date, end date, summaries of activities, and a flag indicating if it is the current streak.
public struct ActivityStreak: Equatable {

    /// The end date of the activity streak.
    public let endDate: Date

    /// The start date of the activity streak.
    public let startDate: Date

    /// Summaries of activities included in the streak.
    public let summaries: [ActivitySummary]

    /// A flag indicating if the activity streak is the current streak.
    public var isCurrentStreak: Bool

    /// Initializes an activity streak with the provided summaries and current streak flag.
    ///
    /// - Parameters:
    ///   - summaries: Summaries of activities included in the streak.
    ///   - isCurrentStreak: A flag indicating if the activity streak is the current streak. Default value is `false`.
    /// - Returns: An initialized activity streak, or `nil` if the provided summaries are empty.
    public init?(
        summaries: [ActivitySummary],
        isCurrentStreak: Bool = false
    ) {
        guard let start = summaries.first,
              let end = summaries.last
        else { return nil }

        self.startDate = start.date
        self.endDate = end.date
        self.summaries = summaries
        self.isCurrentStreak = isCurrentStreak
    }
}
