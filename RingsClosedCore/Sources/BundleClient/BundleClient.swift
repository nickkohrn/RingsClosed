import Dependencies
import DependenciesMacros
import Foundation

/// A client for accessing information about a `Bundle`.
@DependencyClient
public struct BundleClient: Sendable {
    /// Retrieves the build number of the app's bundle.
    public var build: @Sendable () -> String? = { nil }

    /// Retrieves the display name of the app's bundle.
    public var displayName: @Sendable () -> String? = { nil }

    /// Retrieves the version number of the app's bundle.
    public var version: @Sendable () -> String? = { nil }
}

extension BundleClient: DependencyKey {
    public static let liveValue: BundleClient = {
        let bundle = Bundle.main
        return Self(
            build: { bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String },
            displayName: { bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String },
            version: { bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String }
        )
    }()
}
