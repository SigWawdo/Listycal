
import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 1
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

#Preview {
    ContentView()
}
