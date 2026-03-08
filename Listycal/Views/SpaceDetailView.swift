import SwiftUI

struct SpaceDetailView: View {
    let space: SpaceItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                RoundedRectangle(cornerRadius: 20)
                    .fill(space.color)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .overlay {
                        VStack(spacing: 8) {
                            Text(space.title)
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                            Text("\(space.eventCount) events")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 24)

                // Events section
                Text("Events")
                    .font(.headline)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)

                VStack(spacing: 0) {
                    ForEach(0..<space.eventCount, id: \.self) { i in
                        VStack(spacing: 0) {
                            HStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(space.color.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                    .overlay {
                                        Image(systemName: "calendar")
                                            .foregroundColor(space.color)
                                    }
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Event \(i + 1)")
                                        .font(.body)
                                        .fontWeight(.medium)
                                    Text("Tap to view details")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            Divider()
                                .padding(.leading, 68)
                        }
                    }
                }
            }
            .padding(.bottom, 40)
        }
        .navigationTitle(space.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
