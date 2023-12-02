import Foundation

public enum TabBarVisibility: CaseIterable {
    case visible
    
    case invisible
    
    public mutating func toggle() {
        switch self {
        case .visible:
            self = .invisible
        case .invisible:
            self = .visible
        }
    }
}
