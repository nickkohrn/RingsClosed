import Dependencies
import DependenciesMacros
import Foundation
import OSLogClient
import SwiftData

@DependencyClient
public struct LoggingClient {
    public var configure: @Sendable () throws -> Void
    public var deleteAllLogs: @Sendable () throws -> Void
    public var fetchLogs: @Sendable (_ predicate: Predicate<LoggingEntry>?, _ sortDescriptors: [SortDescriptor<LoggingEntry>]) throws -> [LoggingEntry]
    public var pollImmediately: @Sendable () -> Void
    public var registerDriver: @Sendable (_ driver: LogDriver) -> Void
    public var startPolling: @Sendable () -> Void
}

extension LoggingClient: DependencyKey {
    public static var liveValue: LoggingClient = {
        let database = LoggingDatabase()
        return LoggingClient(
            configure: {
                try database.configure()
                if !OSLogClient.isInitialized {
                    #if DEBUG
                    try OSLogClient.initialize(pollingInterval: .custom(1))
                    #else
                    try OSLogClient.initialize()
                    #endif
                }
            }, 
            deleteAllLogs: {
                try database.deleteAll()
            },
            fetchLogs: { predicate, sortDescriptors in
                try database.read(predicate: predicate, sortDescriptors: sortDescriptors)
            },
            pollImmediately: {
                OSLogClient.pollImmediately()
            },
            registerDriver: { driver in
//                if !OSLogClient.isDriverRegistered(withId: driver.id) {
                    OSLogClient.registerDriver(driver)
//                }
            },
            startPolling: {
                OSLogClient.startPolling()
            }
        )
    }()
}
