import Foundation
import OSLog
import OSLogClient
import SwiftUI

public enum LoggingLevel: String, CaseIterable {
    case debug
    case error
    case fault
    case info
    case notice
    case undefined

    public var color: Color {
        switch self {
            case .debug: .gray
            case .error: .yellow
            case .fault: .red
            case .info: .blue
            case .notice: .gray
            case .undefined: .purple
        }
    }

    public var image: Image {
        switch self {
            case .debug: Image("customDebug", bundle: Bundle.module)
            case .error: Image("customError", bundle: Bundle.module)
            case .fault: Image("customFault", bundle: Bundle.module)
            case .info: Image(systemName: "info.square.fill")
            case .notice: Image(systemName: "bell.square.fill")
            case .undefined: Image(systemName: "questionmark.square.fill")
        }
    }

    public var name: String {
        switch self {
            case .debug: "debug"
            case .error: "error"
            case .fault: "fault"
            case .info: "info"
            case .notice: "notice"
            case .undefined: "undefined"
        }
    }

    public init(_ osLogLevel: OSLogEntryLog.Level) {
        switch osLogLevel {
            case .debug: self = .debug
            case .error: self = .error
            case .fault: self = .fault
            case .info: self = .info
            case .notice: self = .notice
            case .undefined: self = .undefined
            @unknown default: self = .undefined
        }
    }

    public init(_ name: String) {
        switch name {
            case Self.debug.name: self = .debug
            case Self.error.name: self = .error
            case Self.fault.name: self = .fault
            case Self.info.name: self = .info
            case Self.notice.name: self = .notice
            case Self.undefined.name: self = .undefined
            default: self = .undefined
        }
    }

    public init(_ osLogLevel: LogDriver.LogLevel) {
        switch osLogLevel {
            case .debug: self = .debug
            case .error: self = .error
            case .fault: self = .fault
            case .info: self = .info
            case .notice: self = .notice
            case .undefined: self = .undefined
        }
    }
}
