//map to show where the nearest marine station is
import SwiftUI
import MapKit
import CoreLocation
import Contacts         

private struct IdentMarina: Identifiable {
    let id = UUID()
    let item: MKMapItem
}

struct MarinaMapTab: View {

    @State private var zip = ""
    @State private var searching = false
    @FocusState private var zipFocused: Bool

    @State private var region = MKCoordinateRegion(
        center: .init(latitude: 37.773, longitude: -122.431),
        span:   .init(latitudeDelta: 0.15, longitudeDelta: 0.15))
    @State private var marinas: [IdentMarina] = []
    @State private var selected: IdentMarina?

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                zipEntryBar

                Map( //used chatGPT to help with creating the map
                    coordinateRegion: $region,
                    interactionModes: [.pan, .zoom],
                    showsUserLocation: false,
                    userTrackingMode: .none,
                    annotationItems: marinas) { marina in

                        MapAnnotation(coordinate: marina.item.placemark.coordinate) {
                            Button {
                                withAnimation {
                                    region = MKCoordinateRegion(
                                        center: marina.item.placemark.coordinate,
                                        span: .init(latitudeDelta: 0.03,
                                                    longitudeDelta: 0.03))
                                }
                                selected = marina
                            } label: {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.red)
                                    .shadow(radius: 1)
                            }
                        }
                }
                .mapStyle(.standard)
                .accentColor(.blue)
                .edgesIgnoringSafeArea(.horizontal)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .gesture(
                    DragGesture().onEnded { _ in zipFocused = false })
                .navigationTitle("Nearby Marinas")
            }
        }
        .sheet(item: $selected) { detailSheet(for: $0.item) }
    }

    private var zipEntryBar: some View {
        HStack {
            TextField("ZIP Code", text: $zip)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .frame(maxWidth: 120)
                .focused($zipFocused)

            Button("Search") { Task { await search() } }
                .buttonStyle(.borderedProminent)
                .disabled(searching || zip.count < 5)
        }
        .padding()
    }

    private func search() async { //used chatGPT to help search for the area try 94123 to see example
        zipFocused = false
        searching = true
        defer { searching = false }

        guard
            let place = try? await CLGeocoder().geocodeAddressString(zip).first,
            let loc   = place.location
        else { return }

        region.center = loc.coordinate

        let req = MKLocalSearch.Request()
        req.naturalLanguageQuery = "marina"
        req.region = region

        if let resp = try? await MKLocalSearch(request: req).start() {
            marinas = resp.mapItems
                .compactMap { $0.placemark.location != nil ? IdentMarina(item: $0) : nil }
                .prefix(10)
                .map { $0 }
        }
    }

    @ViewBuilder private func detailSheet(for item: MKMapItem) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(item.name ?? "Marina")
                .font(.title2).bold()

            if let addr = item.placemark.postalAddress {
                Text(Formatter.postal.string(from: addr))
            }
            if let phone = item.phoneNumber {
                Text("☎︎ \(phone)")
            }
            if let url = item.url {
                Link("Website", destination: url)
            }
            Button("Open in Maps") { item.openInMaps() }
                .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
        .presentationDetents([.medium, .large])
    }
}

extension Formatter {
    static let postal: CNPostalAddressFormatter = {
        let f = CNPostalAddressFormatter()
        f.style = .mailingAddress
        return f
    }()
}

#Preview("Marina Map Tab") {
    MarinaMapTab()
        .previewDevice("iPhone 15")
        .previewDisplayName("Marina Map Tab")
}
