import Foundation

/**
 A set of options for tracking activity streaks.

 Activity streaks represent consecutive periods of engaging in various activities.

 Example usage:
 ```swift
 // Create an options set to track exercise and move streaks
 var options: ActivityStreaksOptions = [.exercise, .move]

 // Check if the options set contains a specific activity
 if options.contains(.stand) {
     print("Standing streaks are being tracked.")
 }
 Note: This struct conforms to the OptionSet protocol, allowing combinations of options using bitwise operations.
 */
public struct ActivityStreaksOptions: OptionSet {
    /// The raw value representing the combination of options.
    public var rawValue: Int

    /// Indicates tracking exercise streaks.
    public static let exercise = ActivityStreaksOptions(rawValue: 1 << 0)

    /// Indicates tracking movement streaks.
    public static let move = ActivityStreaksOptions(rawValue: 1 << 1)

    /// Indicates tracking standing streaks.
    public static let stand = ActivityStreaksOptions(rawValue: 1 << 2)

    /**
     Initializes an `ActivityStreaksOptions` instance with the given raw value.

     - Parameter rawValue: The raw value to represent the combination of options.
     */
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
