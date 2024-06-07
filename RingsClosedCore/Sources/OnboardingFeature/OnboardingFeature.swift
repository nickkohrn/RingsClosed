import ComposableArchitecture
import DesignSystem
import OSLog
import SharedSettings
import SwiftUI

@Reducer
public struct OnboardingFeature {
    @ObservableState
    public struct State: Equatable {
        @SharedReader(.appDisplayName) var appDisplayName

        public init() {}
    }

    public enum Action: Equatable {
        public enum Delegate: Equatable {
            case didFinish
        }

        case delegate(Delegate)
        case onAppear
        case tappedGetStartedButton
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

                case .delegate:
                    return .none

                case .onAppear:
                    return .none

                case .tappedGetStartedButton:
                    return .send(.delegate(.didFinish))

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
        ViewThatFits(in: .vertical) {
            content
            ScrollView { content }
        }
    }

    private var content: some View {
        VStack {
            VStack {
                Text("Welcome to")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .foregroundStyle(.secondary)
                Text(store.appDisplayName)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .fontWeight(.bold)
            .padding(.bottom)
            Text("Close your Activity rings. Extend your streaks.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.secondary)
                .fontWeight(.medium)
        }
        .frame(maxHeight: .infinity)
        .safeAreaInset(edge: .bottom) {
            Button(
                action: { store.send(.tappedGetStartedButton) },
                label: {
                    Text("Get Started")
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
    }
}
