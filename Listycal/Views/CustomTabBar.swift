import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    var onDoubleTap: (Int) -> Void

    var body: some View {
        HStack {
            HStack(spacing: 0) {
                TabBarButton(icon: "diamond.fill", label: "Spaces", index: 0, selectedTab: $selectedTab, onDoubleTap: onDoubleTap)
                TabBarButton(icon: "circle.fill", label: "Spaces", index: 1, selectedTab: $selectedTab, onDoubleTap: onDoubleTap)
            }
            .padding(4)
            .background(.regularMaterial, in: Capsule())
            .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)

            Spacer()

            Button {} label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(width: 50, height: 50)
                    .background(.regularMaterial, in: Circle())
                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
            }
            .accessibilityLabel("Search")
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 36)
    }
}

struct TabBarButton: View {
    let icon: String
    let label: String
    let index: Int
    @Binding var selectedTab: Int
    var onDoubleTap: (Int) -> Void

    var isSelected: Bool { selectedTab == index }

    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(isSelected ? .blue : .secondary)
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(isSelected ? .blue : .secondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 9)
        .background(isSelected ? Color.blue.opacity(0.1) : Color.clear, in: Capsule())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label) tab")
        .accessibilityValue(isSelected ? "selected" : "")
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Double tap to scroll to top")
        .onTapGesture(count: 2) {
            if isSelected {
                onDoubleTap(index)
            } else {
                selectedTab = index
            }
        }
        .onTapGesture(count: 1) {
            selectedTab = index
        }
    }
}
