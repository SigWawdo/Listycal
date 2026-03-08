import SwiftUI

struct SpaceCardGrid: View {
    let spaces: [SpaceItem]
    let layoutMode: LayoutMode
    let namespace: Namespace.ID

    var body: some View {
        if spaces.isEmpty {
            EmptyStateView(
                icon: "square.dashed",
                title: "No Spaces",
                message: "Your spaces will appear here once you create them."
            )
        } else {
            layoutContent
        }
    }

    @ViewBuilder
    private var layoutContent: some View {
        switch layoutMode {
        case .grid:
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                spacing: 12
            ) {
                ForEach(spaces) { space in
                    NavigationLink(destination: SpaceDetailView(space: space)) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(space.color)
                            .overlay {
                                Text("\(space.number)")
                                    .font(.title.bold())
                                    .foregroundColor(.white)
                            }
                            .matchedGeometryEffect(id: space.id, in: namespace)
                            .aspectRatio(1, contentMode: .fit)
                    }
                    .accessibilityLabel("\(space.title), \(space.eventCount) events")
                }
            }

        case .column:
            VStack(spacing: 12) {
                ForEach(spaces) { space in
                    NavigationLink(destination: SpaceDetailView(space: space)) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(space.color)
                            .overlay {
                                Text("\(space.number)")
                                    .font(.title.bold())
                                    .foregroundColor(.white)
                            }
                            .matchedGeometryEffect(id: space.id, in: namespace)
                            .frame(maxWidth: .infinity)
                            .frame(height: 160)
                    }
                    .accessibilityLabel("\(space.title), \(space.eventCount) events")
                }
            }

        case .list:
            VStack(spacing: 0) {
                ForEach(spaces) { space in
                    NavigationLink(destination: SpaceDetailView(space: space)) {
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
                                        .foregroundColor(.primary)
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
                    }
                    .matchedGeometryEffect(id: space.id, in: namespace)
                }
            }
        }
    }
}
