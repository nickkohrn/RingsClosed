import ComposableArchitecture
import Foundation

extension PersistenceReaderKey where Self == PersistenceKeyDefault<InMemoryKey<Bool>> {
    public static var usesWheelchair: Self {
        PersistenceKeyDefault(.inMemory("usesWheelchair"), false)
    }
}
