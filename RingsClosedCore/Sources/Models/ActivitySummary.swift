import Foundation
import HealthKit

/// Represents a summary of activity for a specific date, indicating whether the activity was completed or not.
public struct ActivitySummary: Equatable {

    /// The date of the activity summary.
    public let date: Date

    /// A boolean value indicating whether the activity was completed (`true`) or not (`false`).
    public let didComplete: Bool

    /// Initializes an activity summary with the provided date and completion status.
    ///
    /// - Parameters:
    ///   - date: The date of the activity summary.
    ///   - didComplete: A boolean value indicating whether the activity was completed (`true`) or not (`false`).
    public init(
        date: Date,
        didComplete: Bool
    ) {
        self.date = date
        self.didComplete = didComplete
    }
}
