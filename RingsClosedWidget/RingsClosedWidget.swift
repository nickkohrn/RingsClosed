import Dependencies
import LoggingClient
import OSLog
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    static let logDriver = PersistentLogDriver(
        id: "Widget",
        logSources: [.subsystem("com.bryankohrn.RingsClosed.RingsClosedWidget")]
    )

    private static let logger = Logger(
        subsystem: "com.bryankohrn.RingsClosed.RingsClosedWidget",
        category: "\(Self.self)"
    )

    func placeholder(in context: Context) -> SimpleEntry {
        Self.logger.debug(#function)
        return SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Self.logger.debug(#function)
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Self.logger.debug(#function)
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct RingsClosedWidgetEntryView : View {
    @Dependency(LoggingClient.self) private var loggingClient
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Emoji:")
            Text(entry.emoji)
        }
        .onAppear {
            do {
                try loggingClient.configure()
                loggingClient.registerDriver(driver: Provider.logDriver)
                loggingClient.startPolling()
            } catch {
                print(error)
            }
        }
    }
}

struct RingsClosedWidget: Widget {
    let kind: String = "RingsClosedWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                RingsClosedWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                RingsClosedWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    RingsClosedWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
