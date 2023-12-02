import SwiftUI

@available(iOS 13.0, *)
class TabBarSelection<TabItem: Tabbable>: ObservableObject {
    @Binding var selection: TabItem
    
    init(selection: Binding<TabItem>) {
        self._selection = selection
    }
}
