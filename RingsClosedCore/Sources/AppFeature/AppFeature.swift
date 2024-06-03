import AppDelegateFeature
import ComposableArchitecture
import Dependencies
import HealthClient
import HealthKit
import LoggingClient
import Models
import OSLog
import SwiftUI
#if DEBUG
import LogsFeature
#endif

@Reducer
public struct AppFeature {

    fileprivate static let logger = Logger(
        subsystem: "com.bryankohrn.RingsClosed",
        category: "\(Self.self)"
    )

    fileprivate static let logDriver = PersistentLogDriver(
        id: "App",
        logSources: [.subsystem("com.bryankohrn.RingsClosed")]
    )

    @Dependency(HealthClient.self) public var healthClient
    @Dependency(LoggingClient.self) public var loggingClient

    @Reducer(state: .equatable, action: .equatable)
    public enum Destination {
#if DEBUG
        case logs(LogsFeature)
#endif
    }

    @ObservableState
    public struct State: Equatable {
        public var appDelegate = AppDelegateFeature.State()
        @Presents public var destination: Destination.State?

        public init() {}
    }

    public enum Action: Equatable {
        case appDelegate(AppDelegateFeature.Action)
        case destination(PresentationAction<Destination.Action>)
        case onAppear
        case scenePhaseDidChange(ScenePhase)
#if DEBUG
        case tappedLogsButton
#endif
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.appDelegate, action: /Action.appDelegate) {
            AppDelegateFeature()
        }

        Reduce { state, action in
            switch action {

                case .appDelegate(.delegate(.didFinishLaunching)):
                    Self.logger.info("App did finish launching")
                    do {
                        try loggingClient.configure()
                        Self.logger.debug("Configured logging")
                        return .run { _ in
                            await loggingClient.registerDriver(Self.logDriver)
                            Self.logger.debug("Registered \(PersistentLogDriver.self, privacy: .public)")
                            loggingClient.startPolling()
                        }
                    } catch {
                        Self.logger.error("Failed to configure logging: \(error, privacy: .public)")
                        return .none
                    }

                case .appDelegate:
                    return .none

                case .destination:
                    return .none

                case .onAppear:
                    let isHealthDataAvailable = healthClient.isHealthDataAvailable()
                    Self.logger.info("Health data is available: \(isHealthDataAvailable, privacy: .public)")
                    if isHealthDataAvailable {
                        return .run { send in
                            let toRead: Set<HKObjectType> = [HKObjectType.activitySummaryType()]
                            let authorizationStatus = try await healthClient.statusForAuthorizationRequest(toRead: toRead)
                            switch authorizationStatus {
                                case .unnecessary:
                                    Self.logger.info("Health authorization request status: unnecessary")
                                    Self.logger.info("Calculating streaks")
                                    let summaries = try await healthClient.activitySummaries()
                                    @Dependency(\.date.now) var now
                                    let streaks = ActivityStreaksBuilder.streaks(from: summaries, today: now)
                                    print("EXERCISE:", streaks.exercise.first(where: \.isCurrentStreak)?.summaries.count ?? 0)
                                    print("MOVE:", streaks.move.first(where: \.isCurrentStreak)?.summaries.count ?? 0)
                                    print("STAND:", streaks.stand.first(where: \.isCurrentStreak)?.summaries.count ?? 0)
                                case .unknown:
                                    Self.logger.info("Health authorization request status: unknown")
                                    Self.logger.info("Requesting Health authorization")
                                    try await healthClient.requestAuthorization(toRead: toRead)
                                case .shouldRequest:
                                    Self.logger.info("Health authorization request status: should request")
                                    Self.logger.info("Requesting Health authorization")
                                    try await healthClient.requestAuthorization(toRead: toRead)
                                @unknown default:
                                    Self.logger.info("Health authorization request status: unexpected (\(String(describing: authorizationStatus), privacy: .public)")
                            }
                        } catch: { error, send in
                            // TODO: Handle error
                            Self.logger.error("Error: \(error, privacy: .public)")
                        }
                    } else {
                        return .none
                    }

                case let .scenePhaseDidChange(phase):
                    if phase == .inactive {
                        Self.logger.debug("Scene phase changed to `\(String(describing: phase), privacy: .public)`; polling immediately")
                        loggingClient.pollImmediately()
                    }
                    return .none

                case .tappedLogsButton:
                    state.destination = .logs(LogsFeature.State())
                    return .none

            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

public struct AppFeatureView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Bindable private var store: StoreOf<AppFeature>

    public init(store: StoreOf<AppFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            Text("AppFeature")
                .onChange(of: scenePhase) { _, new in
                    store.send(.scenePhaseDidChange(new))
                }
                .sheet(
                    item: $store.scope(
                        state: \.destination?.logs,
                        action: \.destination.logs
                    )
                ) { store in
                    NavigationStack {
                        LogsFeatureView(store: store)
                    }
                    .preferredColorScheme(.dark)
                }
                .toolbar {
#if DEBUG
                    Button {
                        store.send(.tappedLogsButton)
                    } label: {
                        Label {
                            Text("Logs")
                        } icon: {
                            Image(systemName: "doc.plaintext")
                        }
                    }
#endif
                }
                .onAppear { store.send(.onAppear) }
        }
    }
}

#Preview {
    NavigationStack {
        AppFeatureView(
            store: Store(
                initialState: AppFeature.State(),
                reducer: { AppFeature() }
            )
        )
    }
}
