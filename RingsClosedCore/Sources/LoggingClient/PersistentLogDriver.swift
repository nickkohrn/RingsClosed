import CoreData
import Dependencies
import Foundation
import OSLogClient

public final class PersistentLogDriver: LogDriver {
    private let database = LoggingDatabase()

    public required init(id: String, logSources: [LogSource] = []) {
        super.init(id: id, logSources: logSources)
        try? database.configure()
    }

    public override func processLog(
        level: LogDriver.LogLevel,
        subsystem: String,
        category: String,
        date: Date,
        message: String
    ) {
        let loggingEntry = LoggingEntry(
            category: category,
            date: date,
            level: level.name,
            message: message,
            subsystem: subsystem
        )
        try? database.create(loggingEntry)
    }
}

extension LogDriver.LogLevel {
    fileprivate var name: String {
        switch self {
            case .undefined: "undefined"
            case .debug: "debug"
            case .info: "info"
            case .notice: "notice"
            case .error: "error"
            case .fault: "fault"
        }
    }
}
