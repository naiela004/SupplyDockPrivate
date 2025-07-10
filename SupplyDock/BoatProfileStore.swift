import Foundation
import SwiftUI

class BoatProfileStore: ObservableObject {
    @Published var profiles: [BoatProfile] = []
    
    func addProfile(_ profile: BoatProfile) { //adding new boat profile
        profiles.append(profile)
    }
    
    func updateProfile(_ profile: BoatProfile) { //updating boat profile
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[index] = profile
        }
    }
    
    func deleteProfile(_ profile: BoatProfile) { //deleting an exisitng profile
        profiles.removeAll { $0.id == profile.id }
    }
}
