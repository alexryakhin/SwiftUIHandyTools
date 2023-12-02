import SwiftUI

@available(iOS 13.0, *)
public struct TabBar<TabItem: Tabbable, Content: View>: View {

    @State private var isKeyboardVisible = false

    @Binding private var visibility: TabBarVisibility
    private let selectedItem: TabBarSelection<TabItem>
    private let content: Content
    private let tabBarHeight: CGFloat = 50

    @State private var items: [TabItem]

    public init(
        selection: Binding<TabItem>,
        visibility: Binding<TabBarVisibility> = .constant(.visible),
        @ViewBuilder content: () -> Content
    ) {
        self.selectedItem = .init(selection: selection)
        self.content = content()

        self._items = .init(initialValue: .init())
        self._visibility = visibility
    }

    public var body: some View {
        ZStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .environmentObject(selectedItem)
                .padding(.bottom, isKeyboardVisible ? 0 : tabBarHeight)

            if !isKeyboardVisible {
                VStack {
                    Spacer()
                    VStack(spacing: 0) {
                        Divider()

                        VStack {
                            tabItems
                                .frame(height: tabBarHeight)
                        }
                        .frame(height: tabBarHeight)
                    }
                }
                .visibility(self.visibility)
            }
        }
        .onPreferenceChange(TabBarPreferenceKey.self) { value in
            self.items = value
        }
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillShowNotification,
                object: nil,
                queue: .main
            ) { notification in
                withAnimation {
                    isKeyboardVisible = true
                    visibility = .invisible
                }
            }

            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillHideNotification,
                object: nil,
                queue: .main
            ) { notification in
                withAnimation {
                    isKeyboardVisible = false
                    visibility = .visible
                }
            }
        }
    }

    private var tabItems: some View {
        HStack {
            ForEach(items, id: \.self) { item in
                VStack(spacing: 5.0) {
                    Image(systemName: item.icon)
                        .renderingMode(.template)

                    Text(item.title)
                        .font(.system(size: 10.0, weight: .medium))
                }
                .foregroundColor(selectedItem.selection == item ? .accentColor : .gray)
                .onTapGesture {
                    selectedItem.selection = item
                    selectedItem.objectWillChange.send()
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
