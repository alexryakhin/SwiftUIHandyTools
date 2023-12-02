import SwiftUI

@available(iOS 13.0, *)
struct TabBarPreferenceKey<TabItem: Tabbable>: PreferenceKey {
    static var defaultValue: [TabItem] {
        return .init()
    }
    
    static func reduce(value: inout [TabItem], nextValue: () -> [TabItem]) {
        value.append(contentsOf: nextValue())
    }
}
