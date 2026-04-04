import SwiftUI

// MARK: - Data Model

private struct ChipEvent: Identifiable {
    let id = UUID()
    let title: String
    let shortDate: String
    let fullDate: String
    let attendeeInfo: String?
}

private struct Chip: Identifiable {
    let id: String
    let title: String
    let events: [ChipEvent]
    let style: ChipStyle
    let color: Color
}

private enum ChipStyle {
    case solid
    case photo(String)
}

// MARK: - Dummy View

struct DummyView: View {
    @Binding var scrollToTop: Int
    @State private var layoutMode: LayoutMode = .grid
    @Namespace private var chipNamespace

    private let chips: [Chip] = [
        Chip(id: "upcoming", title: "Upcoming", events: [
            ChipEvent(title: "Saturday 10K", shortDate: "Mar 22", fullDate: "Sat, Mar 22 · 8 AM", attendeeInfo: nil),
            ChipEvent(title: "Flight to LIS", shortDate: "Apr 4", fullDate: "Fri, Apr 4 · 6:30 AM", attendeeInfo: "3/6"),
            ChipEvent(title: "Sunday roast", shortDate: "Mar 23", fullDate: "Sun, Mar 23 · 5 PM", attendeeInfo: nil)
        ], style: .solid, color: Color(.systemGray2)),

        Chip(id: "lisbon", title: "Lisbon Trip 2026", events: [
            ChipEvent(title: "Flight to LIS", shortDate: "Apr 4", fullDate: "Fri, Apr 4 · 6:30 AM", attendeeInfo: "3/6"),
            ChipEvent(title: "Walking tour of Alfama", shortDate: "Apr 5", fullDate: "Sat, Apr 5 · 1:00 PM", attendeeInfo: nil),
            ChipEvent(title: "Dinner at Time Out Market", shortDate: "Apr 5", fullDate: "Sat, Apr 5 · 7:30 PM", attendeeInfo: nil)
        ], style: .photo("https://images.unsplash.com/photo-1585208798174-6cedd86e019a?w=600&q=80"), color: .brown),

        Chip(id: "family", title: "Family Dinners", events: [
            ChipEvent(title: "Sunday roast", shortDate: "Mar 23", fullDate: "Sun, Mar 23 · 5 PM", attendeeInfo: nil),
            ChipEvent(title: "Mom's birthday dinner", shortDate: "Apr 12", fullDate: "Sat, Apr 12 · 7 PM", attendeeInfo: "4/7"),
            ChipEvent(title: "Easter lunch", shortDate: "Apr 20", fullDate: "Sun, Apr 20 · 12 PM", attendeeInfo: nil)
        ], style: .solid, color: Color(red: 0.8, green: 0.5, blue: 0.4)),

        Chip(id: "running", title: "Running Club", events: [
            ChipEvent(title: "Saturday 10K", shortDate: "Mar 22", fullDate: "Sat, Mar 22 · 6 AM", attendeeInfo: nil),
            ChipEvent(title: "Monthly social run", shortDate: "Apr 5", fullDate: "Sat, Apr 5 · 8 AM", attendeeInfo: nil),
            ChipEvent(title: "Half marathon prep", shortDate: "Apr 12", fullDate: "Sat, Apr 12 · 7 AM", attendeeInfo: nil)
        ], style: .solid, color: .green),

        Chip(id: "cats", title: "Cat Sitters", events: [
            ChipEvent(title: "Feed Whiskers", shortDate: "Tomorrow", fullDate: "Tomorrow · 8 AM", attendeeInfo: "1/3"),
            ChipEvent(title: "Vet appointment", shortDate: "Mar 24", fullDate: "Mon, Mar 24 · 2 PM", attendeeInfo: nil),
            ChipEvent(title: "Grooming session", shortDate: "Apr 1", fullDate: "Tue, Apr 1 · 10 AM", attendeeInfo: nil)
        ], style: .photo("https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=600&q=80"), color: .gray),

        Chip(id: "holiday", title: "Holiday Party", events: [
            ChipEvent(title: "Gift exchange", shortDate: "Dec 20", fullDate: "Sat, Dec 20 · 6 PM", attendeeInfo: "8/12"),
            ChipEvent(title: "Venue booking", shortDate: "Nov 15", fullDate: "Fri, Nov 15 · 3 PM", attendeeInfo: nil),
            ChipEvent(title: "Menu planning", shortDate: "Dec 1", fullDate: "Mon, Dec 1 · 12 PM", attendeeInfo: nil)
        ], style: .solid, color: .purple),

        Chip(id: "book", title: "Book Club", events: [
            ChipEvent(title: "No upcoming events", shortDate: "", fullDate: "", attendeeInfo: nil)
        ], style: .solid, color: .brown)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Pinned nav bar
                HStack {
                    Text("sasa")
                        .font(.system(size: 32, weight: .heavy))
                    Spacer()
                    Menu {
                        ForEach(LayoutMode.allCases) { mode in
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    layoutMode = mode
                                }
                            } label: {
                                Label(mode.rawValue, systemImage: mode.icon)
                            }
                        }
                    } label: {
                        Image(systemName: layoutMode.icon)
                            .contentTransition(.symbolEffect(.replace))
                            .font(.body.weight(.medium))
                            .foregroundColor(.primary)
                            .frame(width: 44, height: 44)
                    }
                    Button {} label: {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.body.weight(.medium))
                            .foregroundColor(.primary)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)
                .background(Color(.systemBackground))

                // Scrollable content
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            Color.clear.frame(height: 0).id("top")

                            switch layoutMode {
                            case .grid:
                                gridView
                            case .column:
                                columnView
                            case .list:
                                listView
                            }
                        }
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

    // MARK: - Grid View (169x169 two-column)

    private var gridView: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 12) {
                ForEach(Array(chips.enumerated()).filter { $0.offset % 2 == 0 }, id: \.element.id) { _, chip in
                    GridChipCard(chip: chip)
                        .matchedGeometryEffect(id: chip.id, in: chipNamespace)
                }
            }
            VStack(spacing: 12) {
                ForEach(Array(chips.enumerated()).filter { $0.offset % 2 == 1 }, id: \.element.id) { _, chip in
                    GridChipCard(chip: chip)
                        .matchedGeometryEffect(id: chip.id, in: chipNamespace)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 110)
    }

    // MARK: - Column View (360x169)

    private var columnView: some View {
        VStack(spacing: 12) {
            ForEach(chips) { chip in
                ColumnChipCard(chip: chip)
                    .matchedGeometryEffect(id: chip.id, in: chipNamespace)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 110)
    }

    // MARK: - List View (compact rows)

    private var listView: some View {
        VStack(spacing: 0) {
            ForEach(chips) { chip in
                ListChipRow(chip: chip)
                    .matchedGeometryEffect(id: chip.id, in: chipNamespace)
                if chip.id != chips.last?.id {
                    Divider()
                        .padding(.leading, 72)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 110)
    }
}

// MARK: - Grid Chip Card (169x169)

private struct GridChipCard: View {
    let chip: Chip

    private var isPhoto: Bool {
        if case .photo = chip.style { return true }
        return false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top section: title over image/color
            Text(chip.title)
                .font(.headline)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
                .padding(14)

            Spacer()

            // Bottom section: events on tinted background
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(chip.events.prefix(2).enumerated()), id: \.element.id) { index, event in
                    if index > 0 {
                        Rectangle()
                            .fill(Color.white.opacity(0.4))
                            .frame(height: 0.5)
                            .padding(.horizontal, 12)
                    }
                    GridEventRow(event: event)
                }
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isPhoto ? chip.color.opacity(0.575) : Color.clear)
        }
        .frame(width: 169, height: 169, alignment: .topLeading)
        .background {
            chipBackground(style: chip.style, color: chip.color, width: 169, height: 169)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct GridEventRow: View {
    let event: ChipEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(event.title)
                .font(.caption.weight(.semibold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 1, y: 1)
                .lineLimit(1)

            if !event.fullDate.isEmpty {
                HStack(spacing: 4) {
                    Text(event.fullDate)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)

                    if let info = event.attendeeInfo {
                        Text("•")
                            .foregroundColor(.green)
                            .font(.caption2.weight(.bold))
                        Text(info)
                            .font(.caption2.weight(.medium))
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
    }
}

// MARK: - Column Chip Card (full-width x 169)

private struct ColumnChipCard: View {
    let chip: Chip

    var body: some View {
        ZStack {
            // Full background: image or color fills entire card
            switch chip.style {
            case .solid:
                chip.color
            case .photo(let urlString):
                AsyncImage(url: URL(string: urlString)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    default:
                        chip.color
                    }
                }
                .overlay(Color.black.opacity(0.35))
            }

            // Content overlay
            HStack(spacing: 0) {
                // Left: centered title
                Text(chip.title)
                    .font(.title3.weight(.heavy))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 4, y: 1)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 14)
                    .frame(width: 140, height: 169)

                // Right: events on tinted background
                VStack(alignment: .leading, spacing: 0) {
                    Spacer(minLength: 0)
                    ForEach(Array(chip.events.prefix(3).enumerated()), id: \.element.id) { index, event in
                        if index > 0 {
                            Rectangle()
                                .fill(Color.white.opacity(0.15))
                                .frame(height: 0.5)
                                .padding(.horizontal, 12)
                        }
                        ColumnEventRow(event: event)
                    }
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(chip.color.opacity(0.575))
            }
        }
        .frame(height: 169)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct ColumnEventRow: View {
    let event: ChipEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(event.title)
                .font(.footnote.weight(.semibold))
                .foregroundColor(.white)
                .lineLimit(1)

            if !event.fullDate.isEmpty {
                HStack(spacing: 4) {
                    Text(event.fullDate)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.75))
                        .lineLimit(1)

                    if let info = event.attendeeInfo {
                        Text("•")
                            .foregroundColor(.green)
                            .font(.caption2.weight(.bold))
                        Text(info)
                            .font(.caption2.weight(.medium))
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }
}

// MARK: - List Chip Row (compact)

private struct ListChipRow: View {
    let chip: Chip

    private var firstEvent: ChipEvent? {
        chip.events.first
    }

    var body: some View {
        HStack(spacing: 12) {
            // Icon: photo thumbnail or colored letter
            ZStack {
                switch chip.style {
                case .photo(let urlString):
                    AsyncImage(url: URL(string: urlString)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        default:
                            chip.color
                        }
                    }
                case .solid:
                    chip.color
                        .overlay {
                            Text(String(chip.title.prefix(1)).uppercased())
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                }
            }
            .frame(width: 44, height: 44)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            // Title + event subtitle
            VStack(alignment: .leading, spacing: 2) {
                Text(chip.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)

                if let event = firstEvent {
                    Text(event.title)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            // Date + attendee info
            VStack(alignment: .trailing, spacing: 2) {
                if let event = firstEvent, !event.shortDate.isEmpty {
                    Text(event.shortDate)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                if let event = firstEvent, let info = event.attendeeInfo {
                    HStack(spacing: 3) {
                        Text("•")
                            .foregroundColor(.green)
                            .font(.caption2.weight(.bold))
                        Text(info)
                            .font(.caption.weight(.medium))
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding(.vertical, 12)
    }
}

// MARK: - Shared Background

@ViewBuilder
private func chipBackground(style: ChipStyle, color: Color, width: CGFloat, height: CGFloat) -> some View {
    switch style {
    case .solid:
        RoundedRectangle(cornerRadius: 16)
            .fill(color)
    case .photo(let urlString):
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            default:
                color
            }
        }
        .overlay(Color.black.opacity(0.4))
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    DummyView(scrollToTop: .constant(0))
}
