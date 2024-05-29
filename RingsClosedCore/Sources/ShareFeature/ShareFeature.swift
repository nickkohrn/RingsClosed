import ComposableArchitecture
import OSLog
import SwiftUI

public struct ShareView: UIViewControllerRepresentable {
    public var activityItems: [URL]
    public var applicationActivities: [UIActivity]? = nil

    public init(
        activityItems: [URL],
        applicationActivities: [UIActivity]? = nil
    ) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
    }

    public func makeUIViewController(
        context: UIViewControllerRepresentableContext<ShareView>
    ) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            // Handle error
        }
        return controller
    }

    public func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<ShareView>
    ) {}
}

@Reducer
public struct ShareFeature {
    @ObservableState
    public struct State: Equatable {
        public let activityItems: [URL]

        public init(activityItems: [URL]) {
            self.activityItems = activityItems
        }
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

public struct ShareFeatureView: View {
    @Bindable private var store: StoreOf<ShareFeature>

    public init(store: StoreOf<ShareFeature>) {
        self.store = store
    }

    public var body: some View {
        ShareView(activityItems: store.activityItems)
    }
}
