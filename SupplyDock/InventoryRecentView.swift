import SwiftUI

//for putting the most recent updated inventory item to the front
struct InventoryRecentView: View {
    let items: [InventoryItem]

    var body: some View {
        NavigationView {
            List(items) { item in
                HStack {
                    Label(item.name, systemImage: item.symbol)
                        .font(.headline)

                    Spacer()

                    Text(
                        item.lastModified.formatted(
                            Date.FormatStyle()      
                                .year()
                                .month()
                                .day()
                                .hour()
                                .minute()
                                .second()
                        )
                    )
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Recent Changes")
        }
    }
}
