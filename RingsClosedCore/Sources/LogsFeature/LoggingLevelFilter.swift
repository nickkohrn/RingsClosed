import Foundation
import Tagged

public struct LoggingLevelFilter {
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

extension LoggingLevelFilter: Equatable {}

extension LoggingLevelFilter: Hashable {}

extension LoggingLevelFilter: Identifiable {
    public var id: Tagged<LoggingLevelFilter, String> {
        Tagged(name)
    }
}
