import SwiftUI

public struct CloseButton: UIViewRepresentable {
    public let action: () -> Void
    
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
