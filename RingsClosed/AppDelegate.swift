import AppFeature
import ComposableArchitecture
import UIKit

internal final class AppDelegate: NSObject, UIApplicationDelegate {
    internal let store = Store(
        initialState: AppFeature.State(),
        reducer: { AppFeature() }
    )

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        store.send(.appDelegate(.didFinishLaunching))
        return true
    }
}
