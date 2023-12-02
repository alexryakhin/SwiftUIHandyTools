import SwiftUI

@available(iOS 13.0, *)
struct TabBarViewModifier<TabItem: Tabbable>: ViewModifier {
    @EnvironmentObject private var selectionObject: TabBarSelection<TabItem>
    
    let item: TabItem
    
    func body(content: Content) -> some View {
        Group {
            if item == selectionObject.selection {
                content
            } else {
                Color.clear
            }
        }
        .preference(key: TabBarPreferenceKey.self, value: [item])
    }
}

@available(iOS 13.0, *)
extension View {
    public func tabItem<TabItem: Tabbable>(for item: TabItem) -> some View {
        return self.modifier(TabBarViewModifier(item: item))
    }

    @ViewBuilder func visibility(_ visibility: TabBarVisibility) -> some View {
        switch visibility {
        case .visible:
            self.transition(.move(edge: .bottom))
        case .invisible:
            hidden().transition(.move(edge: .bottom))
        }
    }
}
