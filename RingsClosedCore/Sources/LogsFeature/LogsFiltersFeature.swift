import ComposableArchitecture
import Dependencies
import DesignSystem
import IdentifiedCollections
import LoggingClient
import SwiftUI

@Reducer
public struct LogsFiltersFeature {

    @Dependency(\.calendar) var calendar
    @Dependency(\.date.now) var now
    @Dependency(\.dismiss) public var dismiss

    @ObservableState
    public struct State: Equatable {
        @Shared public var categoryFilters: IdentifiedArrayOf<LoggingCategoryFilter>
        public var dateFilterRangeEnd = Date.now
        public var dateFilterRangeStart = Date.now
        @Shared public var levelFilters: IdentifiedArrayOf<LoggingLevelFilter>
        @Shared public var subsystemFilters: IdentifiedArrayOf<LoggingSubsystemFilter>

        public init(
            categoryFilters: Shared<IdentifiedArrayOf<LoggingCategoryFilter>>,
            levelFilters: Shared<IdentifiedArrayOf<LoggingLevelFilter>>,
            subsystemFilters: Shared<IdentifiedArrayOf<LoggingSubsystemFilter>>
        ) {
            self._categoryFilters = categoryFilters
            self._levelFilters = levelFilters
            self._subsystemFilters = subsystemFilters
        }
    }

    public enum Action: Equatable {
        case tappedCloseButton
        case toggledCategory(LoggingCategoryFilter.ID)
        case toggledLevel(LoggingLevelFilter.ID)
        case toggledSubsystem(LoggingSubsystemFilter.ID)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

                case .tappedCloseButton:
                    return .run { _ in await self.dismiss() }

                case let .toggledCategory(categoryID):
                    state.categoryFilters[id: categoryID]?.isActive.toggle()
                    return .none

                case let .toggledLevel(levelID):
                    state.levelFilters[id: levelID]?.isActive.toggle()
                    return .none

                case let .toggledSubsystem(subsystemID):
                    state.subsystemFilters[id: subsystemID]?.isActive.toggle()
                    return .none

            }
        }
    }
}

public struct LogsFiltersFeatureView: View {
    @Bindable private var store: StoreOf<LogsFiltersFeature>

    public init(store: StoreOf<LogsFiltersFeature>) {
        self.store = store
    }

    public var body: some View {
        List {
            Section {
                if store.levelFilters.isEmpty {
                    Text("None")
                } else {
                    ForEach(store.levelFilters) { levelFilter in
                        Toggle(
                            isOn: Binding(
                                get: { levelFilter.isActive },
                                set: { _ in store.send(.toggledLevel(levelFilter.id)) }
                            ),
                            label: {
                                Label {
                                    Text(levelFilter.name)
                                } icon: {
                                    let level = LoggingLevel(levelFilter.name)
                                    level.image
                                        .foregroundStyle(level.color)
                                }
                            }
                        )
                    }
                }
            } header: {
                Label("Levels", systemImage: "square.stack.3d.up")
            }
            Section {
                if store.subsystemFilters.isEmpty {
                    Text("None")
                } else {
                    ForEach(store.subsystemFilters) { subsystemFilter in
                        Toggle(subsystemFilter.name, isOn: Binding(
                            get: { subsystemFilter.isActive },
                            set: { _ in store.send(.toggledSubsystem(subsystemFilter.id)) }
                        ))
                    }
                }
            } header: {
                Label("Subsystems", systemImage: "gearshape.2")
            }
            Section {
                if store.categoryFilters.isEmpty {
                    Text("None")
                } else {
                    ForEach(store.categoryFilters) { categoryFilter in
                        Toggle(categoryFilter.name, isOn: Binding(
                            get: { categoryFilter.isActive },
                            set: { _ in store.send(.toggledCategory(categoryFilter.id)) }
                        ))
                    }
                }
            } header: {
                Label("Categories", systemImage: "square.grid.3x3")
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                CloseButton { store.send(.tappedCloseButton) }
            }
        }
        .navigationTitle("Filters")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LogsFiltersFeatureView(
            store: Store(
                initialState: LogsFiltersFeature.State(
                    categoryFilters: Shared([]),
                    levelFilters: Shared([]),
                    subsystemFilters: Shared([])
                ),
                reducer: { LogsFiltersFeature() }
            )
        )
    }
}
