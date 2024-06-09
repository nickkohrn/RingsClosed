import Dependencies
import Foundation

/// Represents a streak of activity, defined by a start date, end date, summaries of activities, and a flag indicating if it is the current streak.
public struct ActivityStreak: Equatable {

    /// The end date of the activity streak.
    public let endDate: Date

    /// The start date of the activity streak.
    public let startDate: Date

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
        self.isCurrentStreak = isCurrentStreak
    }
}

// MARK: Formatting

public extension ActivityStreak {
    func formatted<Style: FormatStyle>(_ style: Style) -> Style.FormatOutput where Style.FormatInput == Self {
        style.format(self)
    }
}

// MARK: Date Range Formatting

public struct ActivityStreakDateRangeStyle: FormatStyle {
    public func format(_ value: ActivityStreak) -> String {
        @Dependency(\.calendar) var calendar
        if calendar.isDate(value.startDate, inSameDayAs: value.endDate) {
            return value.endDate.formatted(date: .abbreviated, time: .omitted)
        } else {
            return (value.startDate..<value.endDate).formatted(date: .abbreviated, time: .omitted)
        }
    }
}

extension FormatStyle where Self == ActivityStreakDateRangeStyle {
    /// A `FormatStyle` used for formatting the date range of an `ActivityStreak`. For example, if the streak is only one day, the single date will be
    /// formatted, such as "May 6, 2024". If the streak is longer than one day, the start and end dates will be formatted, such as "May 6 – 7, 2024".
    public static var streakDateRange: ActivityStreakDateRangeStyle { .init() }
}

// MARK: Duration Formatting

public struct ActivityStreakDurationStyle: FormatStyle {
    public func format(_ value: ActivityStreak) -> String {
        // One day must be added to `endDate` since the formatting API requires a `Range<Int>` instead
        // of a `ClosedRange<Int>`.
        @Dependency(\.calendar) var calendar
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: value.endDate) else {
            return "Since \(value.startDate.formatted(date: .abbreviated, time: .omitted))"
        }
        return (value.startDate..<endDate).formatted(.components(style: .abbreviated, fields: [.day]))
    }
}

extension FormatStyle where Self == ActivityStreakDurationStyle {
    /// A `FormatStyle` used for formatting the duration of an `ActivityStreak`. For example, a streak of one day will be formatted as "1 day".
    public static var streakDuration: ActivityStreakDurationStyle { .init() }
}
