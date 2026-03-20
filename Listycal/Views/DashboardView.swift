import SwiftUI

struct DashboardView: View {
    @Binding var scrollToTop: Int
    let spaces: [SpaceItem] = (1...12).map { SpaceItem(number: $0) }

    @State private var layoutMode: LayoutMode = .grid
    @State private var upcomingExpanded: Bool = true
    @Namespace private var cardNamespace

    /// Returns a time-of-day greeting
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        default: return "Good evening"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Color.clear.frame(height: 0).id("top")

                        // Greeting
                        Text("\(greeting), Sig")
                            .font(.largeTitle.bold())
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                            .padding(.bottom, 24)

                        // Upcoming section
                        VStack(alignment: .leading, spacing: 0) {
                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                    upcomingExpanded.toggle()
                                }
                            } label: {
                                HStack {
                                    Text("Upcoming")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: upcomingExpanded ? "chevron.up" : "chevron.down")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.7))
                                        .contentTransition(.symbolEffect(.replace))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)

                            if upcomingExpanded {
                                VStack(spacing: 8) {
                                    UpcomingCard(title: "Lisbon Trip", icon: "airplane", color: .blue)
                                    UpcomingCard(title: "Saturday Runners", icon: "figure.run", color: .green)
                                    UpcomingCard(title: "Team Standup", icon: "person.3.fill", color: .orange)
                                }
                                .padding(.horizontal, 12)
                                .padding(.bottom, 12)
                                .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        .background(Color.purple, in: RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 16)
                        .padding(.bottom, 28)


                        // Spaces section header
                        HStack(spacing: 8) {
                            Text("Spaces")
                                .font(.headline)
                            Text("(\(spaces.count))")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
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
                                    .frame(width: 44, height: 44)
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
        }
    }
}

// MARK: - Upcoming Card

private struct UpcomingCard: View {
    let title: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 28)
            Text(title)
                .font(.body.weight(.medium))
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(color, in: RoundedRectangle(cornerRadius: 12))
    }
}
