import SwiftUI

public struct PageControlView<T: RawRepresentable>: UIViewRepresentable where T.RawValue == Int {

    @Binding internal var currentPage: T
    @Binding internal var numberOfPages: Int

    public init(
        currentPage: Binding<T>,
        numberOfPages: Binding<Int>
    ) {
        _currentPage = currentPage
        _numberOfPages = numberOfPages
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> UIPageControl {
        let uiView = UIPageControl()
        uiView.backgroundStyle = .prominent
        uiView.currentPage = currentPage.rawValue
        uiView.numberOfPages = numberOfPages
        uiView.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged), for: .valueChanged)
        return uiView
    }

    public func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage.rawValue
        uiView.numberOfPages = numberOfPages
    }
}

extension PageControlView {
    public final class Coordinator: NSObject {
        internal var view: PageControlView
        internal init(_ view: PageControlView) {
            self.view = view
        }
        
        @objc func valueChanged(sender: UIPageControl) {
            guard let currentPage = T(rawValue: sender.currentPage) else { return }
            view.currentPage = currentPage
        }
    }
}
