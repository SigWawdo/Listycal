import SwiftUI

struct HomeView: View {
    @Binding var scrollToTop: Int
    let cubeItems: [SpaceItem] = (1...12).map { SpaceItem(number: $0) }
    let spaces: [SpaceItem] = (1...12).map { SpaceItem(number: $0) }

    @State private var layoutMode: LayoutMode = .grid
    @Namespace private var cardNamespace

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Color.clear.frame(height: 0).id("top")
                        // Upcoming section
                        Text("Upcoming")
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 12)

                        if cubeItems.isEmpty {
                            EmptyStateView(
                                icon: "calendar",
                                title: "No Upcoming Events",
                                message: "Events you have coming up will appear here."
                            )
                            .padding(.bottom, 28)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(cubeItems) { item in
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(item.color)
                                            .overlay {
                                                Text("\(item.number)")
                                                    .font(.title2.bold())
                                                    .foregroundColor(.white)
                                            }
                                            .frame(width: 130, height: 130)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            .padding(.bottom, 28)
                        }

                        // Spaces section header
                        HStack(spacing: 8) {
                            Text("Spaces")
                                .font(.headline)
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
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.primary)
                            }
                            .accessibilityLabel("Change layout")
                            .accessibilityValue(layoutMode.rawValue)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 14)

                        SpaceCardGrid(spaces: spaces, layoutMode: layoutMode, namespace: cardNamespace)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 110)
                    }
                    .padding(.top, 8)
                }
                .onChange(of: scrollToTop) {
                    withAnimation(.spring(response: 0.9, dampingFraction: 0.75)) {
                        proxy.scrollTo("top", anchor: .top)
                    }
                }
            }
            .navigationTitle("Spaces")
        }
    }

}
