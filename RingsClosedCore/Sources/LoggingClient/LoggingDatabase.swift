import Foundation
import SwiftData

public final class LoggingDatabase {
    public var container: ModelContainer?
    public var sharedAppContainerIdentifier: String?

    public init(
        container: ModelContainer? = nil,
        sharedAppContainerIdentifier: String? = nil
    ) {
        self.container = container
        self.sharedAppContainerIdentifier = sharedAppContainerIdentifier
    }

    public func configure(isStoredInMemoryOnly: Bool = false) throws {
        let configuration = ModelConfiguration(
            "RingsClosed",
            schema: Schema([
                LoggingEntry.self
            ]),
            isStoredInMemoryOnly: isStoredInMemoryOnly,
            allowsSave: true,
            groupContainer: .identifier("group.com.bryankohrn.RingsClosed"),
            cloudKitDatabase: .none
        )
        container = try ModelContainer(
            for: LoggingEntry.self,
            configurations: configuration
        )
    }

    func create(_ entry: LoggingEntry) throws {
        // TODO: Handle `nil` container
        guard let container else { return }
        let context = ModelContext(container)
        context.insert(entry)
        try context.save()
    }

    func deleteAll() throws {
        // TODO: Handle `nil` container
        guard let container else { return }
        let context = ModelContext(container)
        try context.delete(model: LoggingEntry.self)
    }

    func read(
        predicate: Predicate<LoggingEntry>?,
        sortDescriptors: [SortDescriptor<LoggingEntry>]
    ) throws -> [LoggingEntry] {
        // TODO: Handle `nil` container
        guard let container else { return [] }
        let context = ModelContext(container)
        let fetchDescriptor = FetchDescriptor<LoggingEntry>(
            predicate: predicate,
            sortBy: sortDescriptors
        )
        return try context.fetch(fetchDescriptor)
    }
}
