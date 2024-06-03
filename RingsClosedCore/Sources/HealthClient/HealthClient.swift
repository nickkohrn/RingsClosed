import Dependencies
import DependenciesMacros
import Foundation
import HealthKit
import OSLog

@DependencyClient
public struct HealthClient: Sendable {
    public var activitySummaries: @Sendable () async throws -> [HKActivitySummary]
    public var isHealthDataAvailable: @Sendable () -> Bool = { false }
    public var requestAuthorization: @Sendable (_ toRead: Set<HKObjectType>) async throws -> Void
    public var statusForAuthorizationRequest: @Sendable (_ toRead: Set<HKObjectType>) async throws -> HKAuthorizationRequestStatus
}

extension HealthClient: DependencyKey {
    public static var liveValue: Self {
        let store = HKHealthStore()
        return HealthClient(
            activitySummaries: {
                @Dependency(\.calendar) var calendar
                @Dependency(\.date.now) var now
                var startComponents = calendar.dateComponents([.year, .month, .day], from: .distantPast)
                startComponents.calendar = calendar
                var endComponents = calendar.dateComponents([.year, .month, .day], from: now)
                endComponents.calendar = calendar
                let predicate = HKQuery.predicate(forActivitySummariesBetweenStart: startComponents, end: endComponents)
                let descriptor = HKActivitySummaryQueryDescriptor(predicate: predicate)
                let summaries = try await descriptor.result(for: store)
                return summaries
            },
            isHealthDataAvailable: {
                HKHealthStore.isHealthDataAvailable()
            }, 
            requestAuthorization: { toRead in
                try await store.requestAuthorization(toShare: [], read: toRead)
            },
            statusForAuthorizationRequest: { toRead in
                try await store.statusForAuthorizationRequest(toShare: [], read: toRead)
            }
        )
    }
}
