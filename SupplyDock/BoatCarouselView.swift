import SwiftUI

struct BoatCarouselView: View {
    let profiles: [BoatProfile]
    @Binding var selectedIndex: Int
    var onTapProfile:   (BoatProfile) -> Void
    var onAddInventory: () -> Void
    var onShowRecent:   () -> Void
    var onShowCharts: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            carousel
            navArrowsAndInventoryButton
        }
    }

    private var carousel: some View { //the boat carousel
        ZStack {
            if profiles.indices.contains(selectedIndex) { //used chatGPT for finding how to check if there are already boat profiles available
                TabView(selection: $selectedIndex) {
                    ForEach(profiles.indices, id: \.self) { idx in
                        let p = profiles[idx]
                        VStack {
                            BoatProgressRingView(profile: p)
                                    .padding(.top)

                            Text(p.name)
                                .font(.largeTitle)
                                .bold()
                        }
                        .tag(idx)
                        .padding(.horizontal)
                        .onTapGesture { onTapProfile(p) }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 300)
            } else {
                Text("No boats yet!")
                    .font(.title)
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity,
                           alignment: .center)
            }
        }
    }

    private var navArrowsAndInventoryButton: some View { //left and right arrow and adding new inventory button and chart button
        Group {
            if profiles.count > 0 {
                VStack(spacing: 12) {
                    HStack {
                        Button {
                            withAnimation { selectedIndex = max(0, selectedIndex - 1) } //used chatGPT to create the animation for the button
                        } label: {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(
                                    profiles.count > 1 && selectedIndex > 0 ? .blue : .gray)
                        }
                        .disabled(profiles.count <= 1 || selectedIndex == 0)

                        Spacer()

                        Button {
                            withAnimation { selectedIndex = min(profiles.count - 1, selectedIndex + 1) }
                        } label: {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(
                                    profiles.count > 1 && selectedIndex < profiles.count - 1 ? .blue : .gray)
                        }
                        .disabled(profiles.count <= 1 || selectedIndex == profiles.count - 1)
                    }
                    .padding(.horizontal, 50)

                    HStack(spacing: 12) {
                        Button("Add Inventory") { onAddInventory() }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)

                        Button { onShowRecent() } label: {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.title2)
                                .padding(8)
                                .background(Color(.systemGray6)) //used chatGPT to get the color systemGray6 as a "very light gray color"
                                .clipShape(Circle())
                        }
                        Button { onShowCharts() } label: {
                            Image(systemName: "chart.bar.fill")
                                .font(.title2)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                    }
                }
            }
        }
    }
}
