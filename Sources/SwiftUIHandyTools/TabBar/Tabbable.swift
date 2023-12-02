import Foundation

public protocol Tabbable: Hashable {
    var title: String { get }
    var icon: String { get }
    var selectedIcon: String { get }
}

public extension Tabbable {
    var selectedIcon: String {
        return self.icon
    }
}
