import SwiftUI

/// A button used for closing a modally-presented view.
public struct CloseButton: UIViewRepresentable {
    // MARK: Properties

    /// The action to be performed when tapped.
    public let action: () -> Void

    // MARK: Initialization

    /// Initializes an instance of `CloseButton`.
    /// - Parameter action: The action to be performed when tapped.
    public init(action: @escaping () -> Void) {
        self.action = action
    }

    // MARK: UIViewRepresentable

    public func makeUIView(context: Context) -> UIButton {
        UIButton(type: .close, primaryAction: UIAction { _ in action() })
    }

    public func updateUIView(_ uiView: UIButton, context: Context) {}
}

#Preview {
    NavigationStack {
        Text("")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    CloseButton(action: { })
                }
            }
    }
}
