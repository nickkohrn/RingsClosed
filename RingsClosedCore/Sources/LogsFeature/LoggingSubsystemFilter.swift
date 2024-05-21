import Foundation
import Tagged

public struct LoggingSubsystemFilter {
    public typealias ID = Tagged<Self, String>

    public let name: String
    public var isActive: Bool

    public init(
        name: String,
        isActive: Bool
    ) {
        self.name = name
        self.isActive = isActive
    }
}

extension LoggingSubsystemFilter: Equatable {}

extension LoggingSubsystemFilter: Hashable {}

extension LoggingSubsystemFilter: Identifiable {
    public var id: Tagged<LoggingSubsystemFilter, String> {
        Tagged(name)
    }
}
