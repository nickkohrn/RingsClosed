import ComposableArchitecture
import Foundation

extension PersistenceReaderKey where Self == PersistenceKeyDefault<AppStorageKey<Bool>> {
    public static var hasSeenOnboarding: Self {
        PersistenceKeyDefault(.appStorage("hasSeenOnboarding"), false)
    }
}
