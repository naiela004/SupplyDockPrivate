//view if clicked on a saved profile, lets you edit or delete a profile
import SwiftUI

struct SavedProfileView: View {
    let profile: BoatProfile
    var onEdit: () -> Void
    var onDelete: () -> Void
    
    @State private var showConfirm = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.blue.opacity(0.8)
                    .frame(height: 250)
                    .ignoresSafeArea()
                Image(systemName: "ferry.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(height: 150)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text(profile.name)
                        .font(.largeTitle)
                        .bold()
                    
                    Divider()
                    
                    Group {
                        Text("Make: \(profile.make)")
                        Text("Model: \(profile.model)")
                        Text("Year: \(profile.year)")
                        Text("Type: \(profile.type)")
                        Text("Length: \(profile.length)")
                        
                        if !profile.beam.isEmpty { Text("Beam: \(profile.beam)") }
                        if !profile.depth.isEmpty { Text("Depth: \(profile.depth)") }
                        if !profile.material.isEmpty { Text("Material: \(profile.material)") }
                        if !profile.fuel.isEmpty { Text("Fuel: \(profile.fuel)") }
                        if !profile.tankVolume.isEmpty { Text("Tank Volume: \(profile.tankVolume)") }
                        Text("Tank Permanently Installed? \(profile.tankPermanentlyInstalled ? "Yes" : "No")")
                    }
                    
                    Divider()
                    Text("Engine").font(.headline)
                    Group {
                        if !profile.propulsion.isEmpty { Text("Propulsion: \(profile.propulsion)") }
                        if !profile.horsepower.isEmpty { Text("Horsepower: \(profile.horsepower)") }
                        if !profile.engineHours.isEmpty { Text("Engine Hours: \(profile.engineHours)") }
                    }
                    
                    Divider()
                    Text("Registration").font(.headline)
                    Group {
                        if !profile.registrationState.isEmpty { Text("Registration State: \(profile.registrationState)") }
                        if !profile.registrationNumber.isEmpty { Text("Registration Number: \(profile.registrationNumber)") }
                        if !profile.hin.isEmpty { Text("HIN: \(profile.hin)") }
                        if !profile.expirationDate.isEmpty { Text("Expiration Date: \(profile.expirationDate)") }
                        if !profile.issueDate.isEmpty { Text("Issue Date: \(profile.issueDate)") }
                    }
                    
                    Divider()
                    Text("Personal").font(.headline)
                    Group {
                        if !profile.mainBodyOfWater.isEmpty { Text("Main Body of Water: \(profile.mainBodyOfWater)") }
                        if !profile.activities.isEmpty { Text("Activities: \(profile.activities)") }
                        if !profile.averageRiders.isEmpty { Text("Average Riders: \(profile.averageRiders)") }
                        Text("Trailer? \(profile.trailer ? "Yes" : "No")")
                        Text("Marina? \(profile.marina ? "Yes" : "No")")
                    }
                }
                .padding()
            }
            
            // Buttons
            HStack(spacing: 16) {
                Button("Edit Profile") { onEdit() }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                
                Button("Delete Profile", role: .destructive) {
                    showConfirm = true
                }
                .buttonStyle(.bordered)
            }
            .padding(.bottom)
        }
        .navigationTitle("My Boat Profile")
        .confirmationDialog(
            "Delete this boat profile?",
            isPresented: $showConfirm,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) { onDelete() }
            Button("Cancel", role: .cancel) { }
        }
    }
}

#Preview {
    SavedProfileView(
        profile: BoatProfile(name: "Sunny Skies", make: "Bayliner", model: "VR5",
                             year: "2021", type: "Open", length: "20"),
        onEdit: { },
        onDelete: { }
    )
}
