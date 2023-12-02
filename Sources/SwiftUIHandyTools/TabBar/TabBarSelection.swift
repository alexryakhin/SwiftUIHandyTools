import SwiftUI

class TabBarSelection<TabItem: Tabbable>: ObservableObject {
    @Binding var selection: TabItem
    
    init(selection: Binding<TabItem>) {
        self._selection = selection
    }
}
