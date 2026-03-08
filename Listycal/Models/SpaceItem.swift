import SwiftUI

struct SpaceItem: Identifiable {
    let id = UUID()
    let number: Int
    var title: String { "Space \(number)" }
    var eventCount: Int { number * 2 }
    var color: Color {
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
        return colors[(number - 1) % colors.count]
    }
}
