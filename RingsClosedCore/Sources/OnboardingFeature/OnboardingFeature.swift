import ComposableArchitecture
import DesignSystem
import HealthClient
import HealthKit
import OSLog
import SwiftUI

@Reducer
public struct OnboardingFeature {

    public static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Self.self)
    )

    @Dependency(HealthClient.self) public var healthClient

    public enum Tab: Int, CaseIterable, Equatable {
        case welcome
        case health
    }

    @ObservableState
    public struct State: Equatable {
        public var currentTab = Tab.welcome
        public var health = OnboardingHealthAuthorizationFeature.State()
        @Shared public var objectTypes: Set<HKObjectType>
        public var welcome = OnboardingWelcomeFeature.State()

        public init() {
            self._objectTypes = Shared([
                HKQuantityType(.activeEnergyBurned),
                HKObjectType.activitySummaryType(),
                HKQuantityType(.appleExerciseTime),
                HKQuantityType(.appleStandTime)
            ])
            health = OnboardingHealthAuthorizationFeature.State()
        }
    }

    public enum Action: Equatable {
        public enum Delegate: Equatable {
            case didFinish
        }

        case delegate(Delegate)
        case health(OnboardingHealthAuthorizationFeature.Action)
        case onAppear
        case selectTab(Tab)
        case tappedContinueButton
        case welcome(OnboardingWelcomeFeature.Action)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.health, action: \.health) {
            OnboardingHealthAuthorizationFeature()
        }

        Scope(state: \.welcome, action: \.welcome) {
            OnboardingWelcomeFeature()
        }

        Reduce { state, action in
            switch action {

                case .delegate:
                    return .none

                case .health:
                    return .none

                case .onAppear:
                    return .none

                case let .selectTab(tab):
                    Self.logger.info("Selected onboarding tab \(tab.rawValue, privacy: .public)")
                    state.currentTab = tab
                    return .none

                case .tappedContinueButton:
                    switch state.currentTab {
                        case .welcome:
                            state.currentTab = .health
                            return .none
                        case .health:
                            Self.logger.info("Requesting Health authorization")
                            return .run { send in
                                try await healthClient.requestAuthorization(
                                    toRead: [
                                        .activitySummaryType(),
                                        HKCharacteristicType(.wheelchairUse)
                                    ]
                                )
                                await send(.delegate(.didFinish))
                            } catch: { error, send in
                                // TODO: Handle error
                                Self.logger.error("Error requesting Health authorization: \(error, privacy: .public)")
                            }
                    }

                case .welcome:
                    return .none

            }
        }

    }
}

public struct OnboardingFeatureView: View {
    @Bindable private var store: StoreOf<OnboardingFeature>

    public init(store: StoreOf<OnboardingFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            TabView(selection: $store.currentTab.sending(\.selectTab)) {
                OnboardingWelcomeFeatureView(
                    store: store.scope(
                        state: \.welcome,
                        action: \.welcome
                    )
                )
                .tag(OnboardingFeature.Tab.welcome)
                OnboardingHealthAuthorizationFeatureView(
                    store: store.scope(
                        state: \.health,
                        action: \.health
                    )
                )
                .tag(OnboardingFeature.Tab.health)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.default, value: store.currentTab)
            .background(Color(.systemBackground))
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 16) {
                    PageControlView(
                        currentPage: Binding(
                            get: { store.currentTab },
                            set: { store.send(.selectTab($0)) }
                        ),
                        numberOfPages: .constant(OnboardingFeature.Tab.allCases.count)
                    )
                    Button(
                        action: { store.send(.tappedContinueButton) },
                        label: {
                            Text("Continue")
                                .frame(maxWidth: .infinity)
                                .textCase(.uppercase)
                                .font(.callout)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                        }
                    )
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(.exercise)
                }
                .padding()
                .padding(.horizontal)
            }
        }
        .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    NavigationStack {
        OnboardingFeatureView(
            store: Store(
                initialState: OnboardingFeature.State(),
                reducer: { OnboardingFeature() }
            )
        )
    }
    .preferredColorScheme(.dark)
    .tint(.exercise)
}
