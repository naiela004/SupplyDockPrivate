//for showing both available or missing inventory
import SwiftUI

struct InventorySummaryView: View {
    let inventory: [InventoryItem]
    var onShop: (InventoryItem) -> Void = { _ in }

    private var available: [InventoryItem] { inventory.filter { $0.quantity > 0 } }
    private var missing:   [InventoryItem] { inventory.filter { $0.quantity == 0 } }

    var body: some View {
        VStack(spacing: 0) {
            InventorySectionView(
                title: "Available Inventory",
                items: available.sorted { $0.lastModified > $1.lastModified },
                accent: .green,
                missing: false
            )
            InventorySectionView(
                title: "Missing Items",
                items: missing,
                accent: .red,
                missing: true,
                onShop: onShop
            )
        }
    }
}


#Preview {
    InventorySummaryView(
        inventory: [
            InventoryItem(name: "PFD", symbol: "lifepreserver", quantity: 2),
            InventoryItem(name: "Anchor", symbol: "aqi.medium", quantity: 0)
        ]
    )
}
