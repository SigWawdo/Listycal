import SwiftUI

enum LayoutMode: String, CaseIterable, Identifiable {
    case grid = "Grid"
    case column = "Column"
    case list = "List"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .grid:   return "square.grid.2x2"
        case .column: return "rectangle.stack"
        case .list:   return "list.bullet"
        }
    }
}
