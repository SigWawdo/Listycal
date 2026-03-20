
import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 1
    @State private var scrollToTopTab1: Int = 0
    @State private var scrollToTopTab2: Int = 0
    @State private var scrollToTopTab3: Int = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0:
                    SpacesView(scrollToTop: $scrollToTopTab1)
                case 2:
                    DashboardView(scrollToTop: $scrollToTopTab3)
                default:
                    HomeView(scrollToTop: $scrollToTopTab2)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(selectedTab: $selectedTab) { tappedTab in
                switch tappedTab {
                case 0: scrollToTopTab1 += 1
                case 2: scrollToTopTab3 += 1
                default: scrollToTopTab2 += 1
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
}
