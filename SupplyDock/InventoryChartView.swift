//used chatGPT to help create bar graph and a chart showing how much of each item we ahve and what percent of required items are available. 
import SwiftUI
import Charts

private struct ChartBucket: Identifiable {
    let id = UUID()
    let name: String
    let value: Double
    let pct: Double
    let color: Color
    let isMissing: Bool
}

struct InventoryChartView: View {
    let inventory: [InventoryItem]

    private var itemBuckets: [ChartBucket] {
        inventory.map { item in
            ChartBucket(name: item.name,
                        value: Double(item.quantity),
                        pct:   0,
                        color: item.quantity == 0 ? .red : .green,
                        isMissing: item.quantity == 0)
        }
    }

    private var summaryBuckets: [ChartBucket] {
        let total = Double(inventory.count)
        let missing = Double(inventory.filter { $0.quantity == 0 }.count)
        let have = total - missing

        return [
            ChartBucket(name: "Available",
                        value: have,
                        pct:   have / total,
                        color: .green,
                        isMissing: false),
            ChartBucket(name: "Missing",
                        value: missing,
                        pct:   missing / total,
                        color: .red,
                        isMissing: true)
        ]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 40) {
                    Chart(itemBuckets) { bucket in
                        BarMark(
                            x: .value("Item", bucket.name),
                            y: .value("Qty",  bucket.value)
                        )
                        .foregroundStyle(bucket.color)
                        .cornerRadius(4)
                        .annotation(position: .overlay, alignment: .top) {
                            VStack(spacing: 2) {
                                Text(Int(bucket.value), format: .number)
                                Text(bucketPct(bucket), format: .percent .precision(.fractionLength(0)))
                                    .foregroundColor(.secondary)
                                    .font(.caption2)
                            }
                        }
                    }
                    .chartXAxis(.hidden)
                    .chartYAxis { AxisMarks() }
                    .chartLegend(.hidden)
                    .chartYScale(domain: 0...max(1, itemBuckets.map(\.value).max() ?? 1))
                    .frame(height: 260)
                    .padding(.horizontal)
                    .navigationTitle("Inventory Charts")

                    Chart(summaryBuckets) { part in
                        SectorMark(
                            angle: .value("Count", part.value),
                            innerRadius: .ratio(0.55),
                            angularInset: 1
                        )
                        .foregroundStyle(part.color)
                        .annotation(position: .overlay) {
                            Text(part.pct, format: .percent .precision(.fractionLength(0)))
                                .font(.caption .weight(.semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .chartLegend(position: .bottom)
                    .frame(width: 250, height: 250)
                    .padding()
                }
            }
        }
    }

    private func bucketPct(_ bucket: ChartBucket) -> Double {
        guard let total = inventory.first.map({ _ in Double(inventory.count) }) else { return 0 }
        return bucket.value / total
    }
}

#Preview {
    InventoryChartView(
        inventory: [
            InventoryItem(name: "Wearable PFDs", symbol: "lifepreserver.fill", quantity: 2),
            InventoryItem(name: "Fire Extinguisher", symbol: "flame.fill",      quantity: 0),
            InventoryItem(name: "Anchor",            symbol: "aqi.medium",      quantity: 1),
            InventoryItem(name: "Boarding Ladder",   symbol: "arrow.up.and.down.circle", quantity: 0)
        ]
    )
}
