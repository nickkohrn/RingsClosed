import ComposableArchitecture
import DesignSystem
import OSLog
import SharedSettings
import SwiftUI

@Reducer
public struct OnboardingHealthAuthorizationFeature {
    @ObservableState
    public struct State: Equatable {
        @SharedReader(.appDisplayName) var appDisplayName

        public init() {}
    }

    public enum Action: Equatable {
        case onAppear
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

                case .onAppear:
                    return .none

            }
        }
    }
}

public struct OnboardingHealthAuthorizationFeatureView: View {
    @Bindable private var store: StoreOf<OnboardingHealthAuthorizationFeature>

    public init(store: StoreOf<OnboardingHealthAuthorizationFeature>) {
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
                Image.Icon.appleHealthIcon
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("Works With")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .foregroundStyle(.secondary)
                Text("Apple Health")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .fontWeight(.bold)
            .padding(.bottom)
            Text("To calculate your Activity streaks, \(store.appDisplayName) needs access to some of your Apple Health information. Your Health information will not be shared with anyone.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.secondary)
                .fontWeight(.medium)
        }
        .padding()
        .padding(.horizontal)
    }
}

#Preview {
    OnboardingHealthAuthorizationFeatureView(store: StoreOf<OnboardingHealthAuthorizationFeature>(
        initialState: OnboardingHealthAuthorizationFeature.State(),
        reducer: { OnboardingHealthAuthorizationFeature() }
    ))
    .preferredColorScheme(.dark)
}
