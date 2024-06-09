import SwiftUI

extension Image {
    public struct Icon {
        public static let appleHealthIcon = Image(.appleHealth)

        private init() {}
    }

    public struct Symbol {
        public static let exercise = Image(systemName: "figure.run")
        public static let move = Image(systemName: "figure.walk")
        public static let stand = Image(systemName: "figure.stand")

        private init() {}
    }
}
