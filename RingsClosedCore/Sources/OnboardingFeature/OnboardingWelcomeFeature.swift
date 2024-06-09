import ComposableArchitecture
import DesignSystem
import OSLog
import SharedSettings
import SwiftUI

@Reducer
public struct OnboardingWelcomeFeature {
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
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

                case .delegate:
                    return .none

                case .onAppear:
                    return .none

            }
        }
    }
}

public struct OnboardingWelcomeFeatureView: View {
    @Bindable private var store: StoreOf<OnboardingWelcomeFeature>

    public init(store: StoreOf<OnboardingWelcomeFeature>) {
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
            VStack(alignment: .leading) {
                // TODO: Place app icon here
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
        .padding()
        .padding(.horizontal)
    }
}

#Preview {
    OnboardingWelcomeFeatureView(store: StoreOf<OnboardingWelcomeFeature>(
        initialState: OnboardingWelcomeFeature.State(),
        reducer: { OnboardingWelcomeFeature() }
    ))
    .preferredColorScheme(.dark)
}
