//for putting together the view of availbale or missing inventory
import SwiftUI

struct InventorySectionView: View {
    let title: String
    let items: [InventoryItem]
    let accent: Color         
    let missing: Bool
    var onShop: ((InventoryItem) -> Void)? = nil

    var body: some View {
        if items.isEmpty {
            EmptyView()
        } else {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(accent)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(items) { item in tile(for: item) }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    @ViewBuilder
    private func tile(for item: InventoryItem) -> some View {
        let content = VStack(spacing: 8) {
            Image(systemName: item.symbol)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(12)
                .background(accent.opacity(0.15))
                .clipShape(Circle())

            Text(item.name)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundColor(.primary)

            if missing {
                if item.link != nil {
                    Text("Shop Now")
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 12)
                        .background(accent)
                        .clipShape(Capsule())
                } else {
                    Text("Not Purchasable")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("\(item.quantity)")
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(.secondary)
            }

        }
        .frame(width: 120)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.white))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )

        if missing && item.link != nil{
            Button { onShop?(item) } label: { content }
                .buttonStyle(.plain)
        } else {
            content
        }
    }
}

#Preview {
    InventorySectionView(
        title: "Missing Items",
        items: [
            InventoryItem(name: "Wearable PFDs", symbol: "lifepreserver.fill", quantity: 0),
            InventoryItem(name: "Fire Extinguisher", symbol: "flame.fill", quantity: 0)
        ],
        accent: .red,
        missing: true,
        onShop: { _ in }
    )
}
