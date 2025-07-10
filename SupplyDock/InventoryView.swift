//for the list of inventory items and adding or deleting items from there. 
import SwiftUI

struct InventoryView: View {
    @Binding var inventory: [InventoryItem]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach($inventory) { $item in
                            HStack {
                                Label(item.name, systemImage: item.symbol)
                                    .frame(width: 150, alignment: .leading)

                                Spacer()

                                Button(action: {
                                    if item.quantity > 0 {
                                        item.quantity -= 1
                                        item.lastModified = .now
                                    }
                                }) {
                                    Image(systemName: "minus.circle")
                                        .font(.title2)
                                }

                                Text("\(item.quantity)")
                                    .frame(width: 40, height: 30)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(6)

                                Button(action: {
                                    item.quantity += 1
                                    item.lastModified = .now
                                }) {
                                    Image(systemName: "plus.circle")
                                        .font(.title2)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }

                Spacer()

                Button("Done") {
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding([.horizontal, .bottom])
            }
            .navigationTitle("Boat Inventory")
        }
    }
}

#Preview {
    InventoryView(inventory: .constant([
        InventoryItem(name: "Life Jacket", symbol: "figure.wave", quantity: 2),
        InventoryItem(name: "First Aid Kit", symbol: "cross.case", quantity: 1),
        InventoryItem(name: "Fire Extinguisher", symbol: "flame", quantity: 1),
        InventoryItem(name: "Anchor", symbol: "aqi.medium", quantity: 1),
        InventoryItem(name: "Ladder", symbol: "arrow.up.and.down.circle", quantity: 0)
    ]))
}
