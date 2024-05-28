import Foundation

extension URL {
    public static let shareableLogs = URL.temporaryDirectory.appending(path: "logs.txt")
}
