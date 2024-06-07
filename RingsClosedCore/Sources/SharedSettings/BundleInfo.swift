import ComposableArchitecture
import Foundation

public extension PersistenceReaderKey where Self == InMemoryKey<String> {
    static var appDisplayName: Self {
        inMemory("appDisplayName")
    }
}

extension PersistenceReaderKey where Self == PersistenceKeyDefault<InMemoryKey<String>> {
    public static var appDisplayName: Self {
        PersistenceKeyDefault(.inMemory("appDisplayName"), "")
    }
}
