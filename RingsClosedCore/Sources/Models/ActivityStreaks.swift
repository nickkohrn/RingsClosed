import Foundation

/// Represents a collection of activity streaks for different types of activities.
public struct ActivityStreaks: Equatable {

    /// An array of activity streaks for exercise.
    public let exercise: [ActivityStreak]

    /// An array of activity streaks for movement.
    public let move: [ActivityStreak]

    /// An array of activity streaks for standing.
    public let stand: [ActivityStreak]

    /// Initializes a collection of activity streaks with the provided activity streaks for exercise, movement, and standing.
    ///
    /// - Parameters:
    ///   - exercise: An array of activity streaks for exercise.
    ///   - move: An array of activity streaks for movement.
    ///   - stand: An array of activity streaks for standing.
    public init(
        exercise: [ActivityStreak] = [],
        move: [ActivityStreak] = [],
        stand: [ActivityStreak] = []
    ) {
        self.exercise = exercise
        self.move = move
        self.stand = stand
    }
}
