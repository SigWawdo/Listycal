
import SwiftUI

// MARK: - Models

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

// MARK: - Root

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var scrollToTopTab1: Int = 0
    @State private var scrollToTopTab2: Int = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if selectedTab == 0 {
                    SpacesView(scrollToTop: $scrollToTopTab1)
                } else {
                    HomeView(scrollToTop: $scrollToTopTab2)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(selectedTab: $selectedTab) { tappedTab in
                if tappedTab == 0 { scrollToTopTab1 += 1 }
                else { scrollToTopTab2 += 1 }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Custom Tab Bar

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    var onDoubleTap: (Int) -> Void

    var body: some View {
        HStack {
            HStack(spacing: 0) {
                TabBarButton(icon: "diamond.fill", label: "Tab 1", index: 0, selectedTab: $selectedTab, onDoubleTap: onDoubleTap)
                TabBarButton(icon: "circle.fill", label: "Tab 2", index: 1, selectedTab: $selectedTab, onDoubleTap: onDoubleTap)
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

// MARK: - Spaces View

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

                    contentLayout
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
            } // ScrollViewReader
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
    }

    // MARK: Layouts

    @ViewBuilder
    var contentLayout: some View {
        switch layoutMode {
        case .grid:
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                spacing: 12
            ) {
                ForEach(spaces) { space in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(space.color)
                        .overlay {
                            Text("\(space.number)")
                                .font(.title.bold())
                                .foregroundColor(.white)
                        }
                        .matchedGeometryEffect(id: space.id, in: cardNamespace)
                        .aspectRatio(1, contentMode: .fit)
                }
            }

        case .column:
            VStack(spacing: 12) {
                ForEach(spaces) { space in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(space.color)
                        .overlay {
                            Text("\(space.number)")
                                .font(.title.bold())
                                .foregroundColor(.white)
                        }
                        .matchedGeometryEffect(id: space.id, in: cardNamespace)
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                }
            }

        case .list:
            VStack(spacing: 0) {
                ForEach(spaces) { space in
                    VStack(spacing: 0) {
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(space.color)
                                .frame(width: 44, height: 44)
                                .overlay {
                                    Text("\(space.number)")
                                        .font(.headline.bold())
                                        .foregroundColor(.white)
                                }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(space.title)
                                    .font(.body)
                                    .fontWeight(.medium)
                                Text("\(space.eventCount) events")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 12)
                        Divider()
                    }
                    .matchedGeometryEffect(id: space.id, in: cardNamespace)
                }
            }
        }
    }
}

// MARK: - Home View (Tab 2)

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
                    // Horizontal scroll section
                    Text("Content area")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)

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

                    // Spaces section header
                    HStack(spacing: 8) {
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

                        Button {} label: {
                            Text("Spaces >")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 14)

                    spacesLayout
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
            } // ScrollViewReader
            .navigationTitle("Spaces")
        }
    }

    @ViewBuilder
    var spacesLayout: some View {
        switch layoutMode {
        case .grid:
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                spacing: 12
            ) {
                ForEach(spaces) { space in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(space.color)
                        .overlay {
                            Text("\(space.number)")
                                .font(.title.bold())
                                .foregroundColor(.white)
                        }
                        .matchedGeometryEffect(id: space.id, in: cardNamespace)
                        .aspectRatio(1, contentMode: .fit)
                }
            }

        case .column:
            VStack(spacing: 12) {
                ForEach(spaces) { space in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(space.color)
                        .overlay {
                            Text("\(space.number)")
                                .font(.title.bold())
                                .foregroundColor(.white)
                        }
                        .matchedGeometryEffect(id: space.id, in: cardNamespace)
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                }
            }

        case .list:
            VStack(spacing: 0) {
                ForEach(spaces) { space in
                    VStack(spacing: 0) {
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(space.color)
                                .frame(width: 44, height: 44)
                                .overlay {
                                    Text("\(space.number)")
                                        .font(.headline.bold())
                                        .foregroundColor(.white)
                                }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(space.title)
                                    .font(.body)
                                    .fontWeight(.medium)
                                Text("\(space.eventCount) events")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 12)
                        Divider()
                    }
                    .matchedGeometryEffect(id: space.id, in: cardNamespace)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
