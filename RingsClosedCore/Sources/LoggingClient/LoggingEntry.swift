import Foundation
import SwiftData

@Model public final class LoggingEntry: Codable {
    public var category: String
    public let date: Date
    public var level: String
    public let message: String
    public var subsystem: String

    private enum CodingKeys: CodingKey {
        case category
        case date
        case level
        case message
        case subsystem
    }

    public init(
        category: String,
        date: Date,
        level: String,
        message: String,
        subsystem: String
    ) {
        self.category = category
        self.date = date
        self.level = level
        self.message = message
        self.subsystem = subsystem
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        category = try container.decode(String.self, forKey: .category)
        date = try container.decode(Date.self, forKey: .date)
        level = try container.decode(String.self, forKey: .level)
        message = try container.decode(String.self, forKey: .message)
        subsystem = try container.decode(String.self, forKey: .subsystem)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(category, forKey: .category)
        try container.encode(date, forKey: .date)
        try container.encode(level, forKey: .level)
        try container.encode(message, forKey: .message)
        try container.encode(subsystem, forKey: .subsystem)
    }
}
