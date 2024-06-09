import ComposableArchitecture
import DesignSystem
import HealthClient
import HealthKit
import Models
import OSLog
import SwiftUI

@Reducer
public struct StreaksFeature {

    public static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Self.self)
    )

    @ObservableState
    public struct State: Equatable {
        public var streaks: ActivityStreaks

        public init(streaks: ActivityStreaks = ActivityStreaks()) {
            self.streaks = streaks
        }
    }

    public enum Action: Equatable {
        case calculateStreaks
        case didCalculateStreaks(ActivityStreaks)
        case onAppear
    }

    public init() {}

    public var body: some ReducerOf<Self> {

        Reduce { state, action in
            switch action {

                case .calculateStreaks:
                    Self.logger.debug("Calculating streaks")
                    return .run { send in
                        @Dependency(HealthClient.self) var healthClient
                        @Dependency(\.date.now) var now
                        let summaries = try await healthClient.activitySummaries()
                        let streaks = ActivityStreaksBuilder.streaks(
                            for: [.exercise, .move, .stand],
                            summaries: summaries,
                            today: now
                        )
                        await send(.didCalculateStreaks(streaks))
                    } catch: { error, send in
                        Self.logger.error("Error calculating streaks: \(error, privacy: .public)")
                    }

                case let .didCalculateStreaks(streaks):
                    Self.logger.debug("Calculated streaks: \(String(describing: streaks), privacy: .private)")
                    state.streaks = streaks
                    return .none

                case .onAppear:
                    return .none

            }
        }

    }
}

public struct StreaksFeatureView: View {
    @Bindable private var store: StoreOf<StreaksFeature>
    @State private var streakSymbolSize = CGSize.zero

    public init(store: StoreOf<StreaksFeature>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(alignment: .leading) {
                    streakHeading(
                        label: { Text("Stand") },
                        icon: { Image.Symbol.stand }
                    )
                    .font(.headline)
                    .foregroundStyle(.cyan)
                    if let currentStreak = store.streaks.stand.first(where: \.isCurrentStreak) {
                        Text(currentStreak.formatted(.streakDuration))
                            .font(.title)
                            .fontWeight(.medium)
                        Text(currentStreak.formatted(.streakDateRange))
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    } else {
                        // TODO: Properly handle VoiceOver and redacted information
                        placeholderDuration
                            .font(.title)
                            .fontWeight(.medium)
                        placeholderDateRange
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .cardBackground()
                VStack(alignment: .leading) {
                    streakHeading(
                        label: { Text("Move") },
                        icon: { Image.Symbol.move }
                    )
                    .font(.headline)
                    .foregroundStyle(.cyan)
                    if let currentStreak = store.streaks.move.first(where: \.isCurrentStreak) {
                        Text(currentStreak.formatted(.streakDuration))
                            .font(.title)
                            .fontWeight(.medium)
                        Text(currentStreak.formatted(.streakDateRange))
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    } else {
                        // TODO: Properly handle VoiceOver and redacted information
                        placeholderDuration
                            .font(.title)
                            .fontWeight(.medium)
                        placeholderDateRange
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .cardBackground()
                VStack(alignment: .leading) {
                    streakHeading(
                        label: { Text("Exercise") },
                        icon: { Image.Symbol.exercise }
                    )
                    .font(.headline)
                    .foregroundStyle(.cyan)
                    if let currentStreak = store.streaks.exercise.first(where: \.isCurrentStreak) {
                        Text(currentStreak.formatted(.streakDuration))
                            .font(.title)
                            .fontWeight(.medium)
                        Text(currentStreak.formatted(.streakDateRange))
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    } else {
                        // TODO: Properly handle VoiceOver and redacted information
                        placeholderDuration
                            .font(.title)
                            .fontWeight(.medium)
                        placeholderDateRange
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .cardBackground()
            }
            .padding()
        }
        .onPreferenceChange(ItemSize.self) {
            streakSymbolSize = $0
        }
        .onAppear { store.send(.onAppear) }
    }

    @ViewBuilder private func streakHeading<Label: View, Icon: View>(
        @ViewBuilder label: () -> Label,
        @ViewBuilder icon: () -> Icon
    ) -> some View {
        HStack {
            icon()
                .background(GeometryReader {
                    Color.clear.preference(key: ItemSize.self,
                                           value: $0.frame(in: .local).size)
                })
                .frame(width: streakSymbolSize.width, height: streakSymbolSize.height)
            label()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder private var placeholderDateRange: some View {
        Text("XXXXXXXX")
            .redacted(reason: .placeholder)
    }

    @ViewBuilder private var placeholderDuration: some View {
        Text("XXXX days")
            .redacted(reason: .placeholder)
    }
}

#Preview("Calculating") {
    StreaksFeatureView(
        store: Store(
            initialState: StreaksFeature.State(),
            reducer: { StreaksFeature() }
        )
    )
}

#Preview("Calculated") {
    let calendar = Calendar.current
    let now = calendar.startOfDay(for: .now)
    let exercise = [
        ActivityStreak(
            summaries: [
                ActivitySummary(
                    date: calendar.date(byAdding: .day, value: -1, to: now)!,
                    didComplete: true
                ),
                ActivitySummary(
                    date: now,
                    didComplete: true
                )
            ],
            isCurrentStreak: true
        )!
    ]
    let move = [
        ActivityStreak(
            summaries: [
                ActivitySummary(
                    date: .now,
                    didComplete: true
                )
            ],
            isCurrentStreak: true
        )!
    ]
    let store = StoreOf<StreaksFeature>(
        initialState: StreaksFeature.State(streaks: ActivityStreaks(
            exercise: exercise,
            move: move,
            stand: []
        )),
        reducer: { StreaksFeature() }
    )
    return StreaksFeatureView(store: store)
}

public struct ItemSize: PreferenceKey {
    public static var defaultValue: CGSize { .zero }

    public static func reduce(
        value: inout Value,
        nextValue: () -> Value
    ) {
        let next = nextValue()
        value = CGSize(
            width: max(value.width, next.width),
            height: max(value.height, next.height)
        )
    }
}

struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius: 4)
    }
}

extension View {
    func cardBackground() -> some View {
        modifier(CardBackground())
    }
}
