//initial view, keeps boat profiles, logs history, inventory etc
import SwiftUI
import SafariServices

struct HomeView: View {
    @StateObject private var store = BoatProfileStore()

    @State private var showForm       = false
    @State private var showInventory  = false
    @State private var selectedProfile: BoatProfile?
    @State private var editingProfile:  BoatProfile?
    @State private var selectedIndex  = 0
    @State private var showRecent = false
    @State private var showCharts = false
    @State private var shopItem: InventoryItem? = nil   

    private var currentInventory: [InventoryItem] {
        guard store.profiles.indices.contains(selectedIndex) else { return [] }
        return store.profiles[selectedIndex].inventory
    }

    var body: some View {
        VStack(spacing: 0) {
            BoatCarouselView(
                profiles: store.profiles,
                selectedIndex: $selectedIndex,
                onTapProfile: { selectedProfile = $0 },
                onAddInventory: { showInventory = true },
                onShowRecent: { showRecent = true },
                onShowCharts: { showCharts = true}
            )

            InventorySummaryView(
                inventory: currentInventory,
                onShop: { shopItem = $0 }
            )

            floatingAddBoatButton
        }
        
        .sheet(isPresented: $showForm, content: profileFormSheet)
        .sheet(isPresented: $showInventory) {
            InventoryView(inventory: $store.profiles[selectedIndex].inventory)
        }
        .sheet(item: $selectedProfile, content: { detailSheet(for: $0) })
        .sheet(isPresented: $showForm) {
            profileFormSheet()
        }
        .sheet(item: $shopItem) { safariSheet(for: $0) }
        .sheet(isPresented: $showRecent) {
            InventoryRecentView(
                items: store.profiles[selectedIndex]
                        .inventory
                        .sorted { $0.lastModified > $1.lastModified }) // newest first
        }
        .sheet(isPresented: $showCharts) {
            InventoryChartView(
                inventory: store.profiles[selectedIndex].inventory
            )
        }
    }
    

    private var floatingAddBoatButton: some View { //button to create new profile
        Color.clear
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    Button {
                        editingProfile = nil
                        showForm = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 12)
                }
            }
    }

    private func profileFormSheet() -> some View { //sheet for profile form
        BoatProfileView(initialProfile: editingProfile ?? BoatProfile()) { profile in
            if editingProfile != nil {
                store.updateProfile(profile)
            } else {
                store.addProfile(profile)
                selectedIndex = store.profiles.count - 1
            }
        }
    }

    private var inventorySheet: some View { //sheet to add or remove inventoy
        InventoryView(inventory: $store.profiles[selectedIndex].inventory)
    }

    private func detailSheet(for p: BoatProfile) -> some View { //sheet for details
        SavedProfileView(
            profile: p,
            onEdit: {
                editingProfile = p
                selectedProfile = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { showForm = true }
            },
            onDelete: {
                store.deleteProfile(p)
                selectedProfile = nil
                if selectedIndex >= store.profiles.count {
                    selectedIndex = max(0, store.profiles.count - 1)
                }
            }
        )
    }

    private func safariSheet(for item: InventoryItem) -> some View { //sheet when opening up a shop link
        let url = item.link
            ?? URL(
                string: "https://www.google.com/search?q=" +
                        (item.name.addingPercentEncoding(
                            withAllowedCharacters: .urlQueryAllowed) ?? "")
            )!

        return SafariView(url: url)
    }
}

struct SafariView: UIViewControllerRepresentable { //used chatGPT to help with opening up safari
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    func updateUIViewController(_ vc: SFSafariViewController, context: Context) {}
}

#Preview { HomeView() }
