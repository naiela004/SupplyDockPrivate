import SwiftUI

struct BoatProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var profile: BoatProfile
    var onSave: (BoatProfile) -> Void
    
    init(initialProfile: BoatProfile, onSave: @escaping (BoatProfile) -> Void) { //used chatGPT for understanding how to use @escaping to indicate the closure is saved
        self._profile = State(initialValue: initialProfile)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView { //adding all fields in the form for a boat profile
            Form {
                Section(header: Text("Boat")) {
                    requiredField("Name", text: $profile.name)
                    optionalField("Make", text: $profile.make)
                    optionalField("Model", text: $profile.model)
                    requiredField("Year", text: $profile.year)
                    requiredField("Type", text: $profile.type)
                    requiredField("Length", text: $profile.length)
                    
                    optionalField("Beam", text: $profile.beam)
                    optionalField("Depth", text: $profile.depth)
                    optionalField("Material", text: $profile.material)
                    optionalField("Fuel", text: $profile.fuel)
                    requiredField("Tank Volume", text: $profile.tankVolume)
                    Toggle("Tank Permanently Installed?", isOn: $profile.tankPermanentlyInstalled)
                }
                
                Section(header: Text("Engine")) {
                    requiredField("Propulsion", text: $profile.propulsion)
                    optionalField("Horsepower", text: $profile.horsepower)
                    optionalField("Engine Hours", text: $profile.engineHours)
                }
                
                Section(header: Text("Registration")) {
                    requiredField("Registration State", text: $profile.registrationState)
                    optionalField("Registration Number", text: $profile.registrationNumber)
                    optionalField("HIN", text: $profile.hin)
                    optionalField("Expiration Date", text: $profile.expirationDate)
                    optionalField("Issue Date", text: $profile.issueDate)
                }
                
                Section(header: Text("Personal")) {
                    optionalField("Main Body of Water", text: $profile.mainBodyOfWater)
                    optionalField("Activities", text: $profile.activities)
                    optionalField("Average # of Riders", text: $profile.averageRiders)
                    Toggle("Trailer?", isOn: $profile.trailer)
                    Toggle("Marina?", isOn: $profile.marina)
                }
                
                Section {
                    Button("Save Profile") {
                        if validateRequiredFields() {
                            onSave(profile)
                            dismiss()
                        } else {
                            print("Please fill in required fields.")
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }

            }
            .navigationTitle("Boat Profile")
        }
    }
        
    func requiredField(_ title: String, text: Binding<String>) -> some View { //special red and star symbol for required field
        HStack {
            Text("\(title)*")
                .foregroundColor(.red)
            TextField(title, text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    func optionalField(_ title: String, text: Binding<String>) -> some View { //plan black for optional
        HStack {
            Text(title)
            TextField(title, text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    func validateRequiredFields() -> Bool { //checks whether all required fields are complete or not
        return !profile.name.isEmpty &&
               !profile.year.isEmpty &&
               !profile.type.isEmpty &&
               !profile.length.isEmpty &&
               !profile.tankVolume.isEmpty &&
               !profile.propulsion.isEmpty &&
               !profile.registrationState.isEmpty
    }

}
