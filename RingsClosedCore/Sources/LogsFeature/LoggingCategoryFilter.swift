import Foundation
import Tagged

public struct LoggingCategoryFilter: Codable, Sendable {
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

extension LoggingCategoryFilter: Equatable {}

extension LoggingCategoryFilter: Hashable {}

extension LoggingCategoryFilter: Identifiable {
    public var id: Tagged<LoggingCategoryFilter, String> {
        Tagged(name)
    }
}
