//If a boat profile has been saved && the user is **not** editing,
//it shows that profile in read-only (SavedProfileView).
//Otherwise it presents BoatProfileView either for creating a new
//boat or editing the existing one.
//All state lives locally with @State; nothing is persisted yet.

import SwiftUI

struct ContentView: View {
    @State private var savedProfile: BoatProfile? = nil
    @State private var editingProfile: BoatProfile? = nil
    @State private var showConfirmDelete = false

    var body: some View {
        if let profile = savedProfile, editingProfile == nil {
            SavedProfileView(
                profile: profile,
                onEdit: {
                    editingProfile = profile
                },
                onDelete: {
                    savedProfile = nil
                }
            )
        } else {
            BoatProfileView(initialProfile: editingProfile ?? BoatProfile()) { profile in
                savedProfile = profile
                editingProfile = nil
            }
        }
    }
}

#Preview {
    ContentView()
}
