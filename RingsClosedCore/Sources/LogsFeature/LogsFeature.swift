import Algorithms
import ComposableArchitecture
import DesignSystem
import LoggingClient
import OSLog
import SwiftUI

// TODO: Make array of log entries an IdentifiedArray
// TODO: Replace direct usage of `LogEntry` reference types with value types (use a type to wrap `LogEntry`)

@Reducer
public struct LogsFeature {

    fileprivate static let logger = Logger(
        subsystem: "com.bryankohrn.RingsClosed",
        category: "\(Self.self)"
    )

    @Dependency(LoggingClient.self) public var loggingClient

    @Reducer(state: .equatable, action: .equatable)
    public enum Destination {
        case confirmationDialog(ConfirmationDialogState<LogsFeature.Action.ConfirmationDialog>)
        case logsFilters(LogsFiltersFeature)
    }

    public struct Section: Equatable, Identifiable {
        public let date: Date
        public let entries: [LoggingEntry]
        public var id: Date { date }

        public init(
            date: Date,
            entries: [LoggingEntry]
        ) {
            self.date = date
            self.entries = entries
        }
    }

    @ObservableState
    public struct State: Equatable {
        public var entries = [Section]()
        @Shared public var categoryFilters: IdentifiedArrayOf<LoggingCategoryFilter>
        @Presents public var destination: Destination.State?
        @Shared public var levelFilters: IdentifiedArrayOf<LoggingLevelFilter>
        public var searchText = ""
        @Shared public var subsystemFilters: IdentifiedArrayOf<LoggingSubsystemFilter>

        public var isSearching: Bool {
            !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }

        public init() {
            self._categoryFilters = Shared([])
            self._levelFilters = Shared([])
            self._subsystemFilters = Shared([])
        }
    }

    public enum Action: Equatable {
        public enum ConfirmationDialog: Equatable {
            case confirmDeletion
        }

        case categoryFiltersDidChange(IdentifiedArrayOf<LoggingCategoryFilter>)
        case destination(PresentationAction<Destination.Action>)
        case levelFiltersDidChange(IdentifiedArrayOf<LoggingLevelFilter>)
        case onAppear
        case searchTextDidChange(String)
        case subsystemFiltersDidChange(IdentifiedArrayOf<LoggingSubsystemFilter>)
        case tappedDeleteButton
        case tappedFiltersButton
        case tappedRefreshButton
        case tappedShareButton
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

                case .categoryFiltersDidChange:
                    return fetchLogs(state: &state)

                case .destination(.presented(.confirmationDialog(.confirmDeletion))):
                    do {
                        try loggingClient.deleteAllLogs()
                    } catch {
                        Self.logger.error("Failed to delete all logs: \(error, privacy: .public)")
                    }
                    return fetchLogs(state: &state)

                case .destination:
                    return .none

                case .levelFiltersDidChange:
                    return fetchLogs(state: &state)

                case .onAppear:
                    return .merge(
                        populateFilters(state: &state),
                        fetchLogs(state: &state),
                        .publisher { [state] in
                            state.$categoryFilters.publisher.map(Action.categoryFiltersDidChange)
                        },
                        .publisher { [state] in
                            state.$levelFilters.publisher.map(Action.levelFiltersDidChange)
                        },
                        .publisher { [state] in
                            state.$subsystemFilters.publisher.map(Action.subsystemFiltersDidChange)
                        }
                    )

                case let .searchTextDidChange(text):
                    state.searchText = text
                    return fetchLogs(state: &state)

                case .subsystemFiltersDidChange:
                    return fetchLogs(state: &state)

                case .tappedDeleteButton:
                    state.destination = .confirmationDialog(
                        ConfirmationDialogState<Action.ConfirmationDialog>(
                            titleVisibility: .visible,
                            title: {
                                TextState("Delete All Logs")
                            },
                            actions: {
                                .destructive(TextState("Delete All Logs"), action: .send(.confirmDeletion))
                            },
                            message: {
                                TextState("Are you sure you want to delete all logs?")
                            }
                        )
                    )
                    return .none

                case .tappedFiltersButton:
                    state.destination = .logsFilters(
                        LogsFiltersFeature.State(
                            categoryFilters: state.$categoryFilters, 
                            levelFilters: state.$levelFilters,
                            subsystemFilters: state.$subsystemFilters
                        )
                    )
                    return .none

                case .tappedRefreshButton:
                    return .concatenate(
                        populateFilters(state: &state),
                        fetchLogs(state: &state)
                    )

                case .tappedShareButton:
                    return .none

            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func populateFilters(state: inout State) -> Effect<Action> {
        do {
            let allEntries = try loggingClient.fetchLogs(
                predicate: #Predicate { _ in true },
                sortDescriptors: [SortDescriptor(\.date, order: .reverse)]
            )
            state.categoryFilters = IdentifiedArray(
                uniqueElements: Set(allEntries.map(\.category))
                    .sorted(using: String.Comparator(.localizedStandard))
                    .map { category in
                        LoggingCategoryFilter(name: category, isActive: true)
                    }
            )
            state.levelFilters = IdentifiedArray(
                uniqueElements: Set(allEntries.map(\.level))
                    .sorted(using: String.Comparator(.localizedStandard))
                    .map { level in
                        LoggingLevelFilter(name: level, isActive: true)
                    }
            )
            state.subsystemFilters = IdentifiedArray(
                uniqueElements: Set(allEntries.map(\.subsystem))
                    .sorted(using: String.Comparator(.localizedStandard))
                    .map { subsystem in
                        LoggingSubsystemFilter(name: subsystem, isActive: true)
                    }
            )
        } catch {
            Self.logger.error("Failed to fetch logs: \(error, privacy: .public)")
        }
        return .none
    }

    private func fetchLogs(state: inout State) -> Effect<Action> {
        @Dependency(\.calendar) var calendar
        @Dependency(\.date.now) var now
        let predicate: Predicate<LoggingEntry>
        let activeCategories = state.categoryFilters.filter(\.isActive).map(\.name)
        let activeLevelFilters = state.levelFilters.filter(\.isActive).map(\.name)
        let activeSubsystems = state.subsystemFilters.filter(\.isActive).map(\.name)
        if state.isSearching {
            let searchText = state.searchText
            predicate = #Predicate<LoggingEntry> { entry in
                entry.message.localizedStandardContains(searchText)
                && activeCategories.contains(entry.category)
                && activeLevelFilters.contains(entry.level)
                && activeSubsystems.contains(entry.subsystem)
            }
        } else {
            predicate = #Predicate<LoggingEntry> { entry in
                activeCategories.contains(entry.category)
                && activeLevelFilters.contains(entry.level)
                && activeSubsystems.contains(entry.subsystem)
            }
        }
        do {
            let entries = try loggingClient.fetchLogs(
                predicate: predicate,
                sortDescriptors: [SortDescriptor(\.date, order: .reverse)]
            )
            let chunkedByDate = entries.chunked {
                calendar.isDate($0.date, equalTo: $1.date, toGranularity: .day)
            }
            var sections = [Section]()
            for chunk in chunkedByDate {
                guard let first = chunk.first else { continue }
                let date = first.date
                let section = Section(date: date, entries: Array(chunk))
                sections.append(section)
            }
            state.entries = sections
        } catch {
            Self.logger.error("Failed to fetch logs: \(error, privacy: .public)")
        }
        return .none
    }
}

public struct LogsFeatureView: View {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSSS"
        return dateFormatter
    }()

    @Environment(\.scenePhase) private var scenePhase
    @Bindable private var store: StoreOf<LogsFeature>

    public init(store: StoreOf<LogsFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            Group {
                if store.entries.isEmpty {
                    if store.isSearching {
                        ContentUnavailableView.search(text: store.searchText)
                    } else {
                        ContentUnavailableView("No Logs", systemImage: "doc.plaintext", description: Text("There are no logs to display."))
                    }
                } else {
                    List {
                        ForEach(store.entries) { section in
                            Section {
                                ForEach(section.entries) { entry in
                                    VStack(alignment: .leading) {
                                        message(for: entry)
                                            .padding(.bottom, 4)
                                        VStack(alignment: .leading) {
                                            level(for: entry)
                                            timestamp(for: entry)
                                            subsystem(for: entry)
                                            category(for: entry)
                                        }
                                        .imageScale(.large)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    }
                                }
                            } header: {
                                Text(section.date.formatted(.dateTime.year().month().day()))
                            }
                        }
                    }
                    .listStyle(.plain)
                    .headerProminence(.increased)
                }
            }
            .confirmationDialog(
                store: store.scope(
                    state: \.$destination.confirmationDialog,
                    action: \.destination.confirmationDialog
                )
            )
            .searchable(
                text: $store.searchText.sending(\.searchTextDidChange),
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search"
            )
            .sheet(
                item: $store.scope(
                    state: \.destination?.logsFilters,
                    action: \.destination.logsFilters
                )
            ) { store in
                NavigationStack {
                    LogsFiltersFeatureView(store: store)
                }
                .presentationDetents([.medium, .large])
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
                    Button {
                        store.send(.tappedFiltersButton)
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        store.send(.tappedDeleteButton)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .disabled(store.entries.isEmpty)
                    Spacer()
                    Button {
                        store.send(.tappedRefreshButton)
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                    Spacer()
                }
            }
            .navigationTitle("Logs")
            .fontDesign(.monospaced)
            .onAppear { store.send(.onAppear) }
        }
    }

    @ViewBuilder private func category(for entry: LoggingEntry) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "square.grid.3x3")
            Text(entry.category)
        }
    }

    @ViewBuilder private func level(for entry: LoggingEntry) -> some View {
        let level = LoggingLevel(rawValue: entry.level) ?? .undefined
        HStack(spacing: 4) {
            level.image
                .foregroundStyle(level.color)
            Text(level.name)
        }
    }

    @ViewBuilder private func message(for entry: LoggingEntry) -> some View {
        Text(entry.message)
            .fontWeight(.semibold)
            .font(.callout)
    }

    @ViewBuilder private func subsystem(for entry: LoggingEntry) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "gearshape.2")
            Text(entry.subsystem)
        }
    }

    @ViewBuilder private func timestamp(for entry: LoggingEntry) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "clock")
            Text(entry.date, formatter: Self.dateFormatter)
        }
    }
}

#Preview {
    NavigationStack {
        LogsFeatureView(
            store: Store(
                initialState: LogsFeature.State(),
                reducer: { LogsFeature() }
            )
        )
    }
}
