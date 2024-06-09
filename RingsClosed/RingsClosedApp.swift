import AppDelegateFeature
import AppFeature
import SwiftUI

@main
struct RingsClosedApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            AppFeatureView(store: appDelegate.store)
        }
    }
}
