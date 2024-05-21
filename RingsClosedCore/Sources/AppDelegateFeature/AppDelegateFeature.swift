import ComposableArchitecture
import Foundation
import UIKit

@Reducer
public struct AppDelegateFeature {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action: Equatable {
        public enum Delegate: Equatable {
            case didFinishLaunching
        }

        case delegate(Delegate)
        case didFinishLaunching
    }
    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

                case .delegate:
                    return .none

                case .didFinishLaunching:
                    return .send(.delegate(.didFinishLaunching))
            }
        }
    }
}
