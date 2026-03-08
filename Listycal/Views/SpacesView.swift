import SwiftUI

struct SpacesView: View {
    @Binding var scrollToTop: Int
    @State private var layoutMode: LayoutMode = .grid
    @Namespace private var cardNamespace

    let spaces: [SpaceItem] = (1...12).map { SpaceItem(number: $0) }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Color.clear.frame(height: 0).id("top")
                        Text("Content area")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)

                        SpaceCardGrid(spaces: spaces, layoutMode: layoutMode, namespace: cardNamespace)
                            .padding(.horizontal, 16)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 110)
                }
                .onChange(of: scrollToTop) {
                    withAnimation(.spring(response: 0.9, dampingFraction: 0.75)) {
                        proxy.scrollTo("top", anchor: .top)
                    }
                }
            }
            .navigationTitle("Spaces")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    layoutToggle
                }
            }
        }
    }

    // MARK: Toggle Button

    var layoutToggle: some View {
        Menu {
            ForEach(LayoutMode.allCases) { mode in
                Button {
                    withAnimation(.spring(response: 0.9, dampingFraction: 0.75)) {
                        layoutMode = mode
                    }
                } label: {
                    Label(mode.rawValue, systemImage: mode.icon)
                }
            }
        } label: {
            Image(systemName: layoutMode.icon)
                .contentTransition(.symbolEffect(.replace))
                .frame(width: 32, height: 32)
        }
        .accessibilityLabel("Change layout")
        .accessibilityValue(layoutMode.rawValue)
    }

}
