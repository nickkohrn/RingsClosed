import SwiftUI

public extension ShapeStyle where Self == Color {
    /// A predefined color representing exercise activity.
    static var exercise: Color { Color(.exercise) }

    /// A predefined color representing movement activity.
    static var move: Color { Color(.move) }

    /// A predefined color representing standing activity.
    static var stand: Color { Color(.stand) }
}
