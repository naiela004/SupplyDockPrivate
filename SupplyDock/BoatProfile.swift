import Foundation

struct BoatProfile: Identifiable, Codable { //all fields in a baot profile
    let id: UUID = UUID()
    var inventory: [InventoryItem] = BoatProfile.defaultInventoryItems 
    
    var name: String = ""
    var make: String = ""
    var model: String = ""
    var year: String = ""
    var type: String = ""
    var length: String = ""
    
    var beam: String = ""
    var depth: String = ""
    var material: String = ""
    var fuel: String = ""
    var tankVolume: String = ""
    var tankPermanentlyInstalled: Bool = false
    
    var propulsion: String = ""
    var horsepower: String = ""
    var engineHours: String = ""
    
    var registrationState: String = ""
    var registrationNumber: String = ""
    var hin: String = ""
    var expirationDate: String = ""
    var issueDate: String = ""
    
    var mainBodyOfWater: String = ""
    var activities: String = ""
    var averageRiders: String = ""
    var trailer: Bool = false
    var marina: Bool = false
}


struct InventoryItem: Identifiable, Codable { //inventory item as a struct
    let id = UUID()
    var name: String
    var symbol: String
    var quantity: Int 
    var link: URL? = nil
    var lastModified: Date = .now 
}


extension BoatProfile {
    static let defaultInventoryItems: [InventoryItem] = [ //all inventory items and links to shop them
        InventoryItem(name: "Vessel Registration", symbol: "doc.text.fill", quantity: 0),
        InventoryItem(name: "Validation Decal", symbol: "checkmark.seal.fill", quantity: 0),
        InventoryItem(name: "Registration Numbers", symbol: "number.square.fill", quantity: 0),
        InventoryItem(name: "Boating Safety Certificate", symbol: "book.closed.fill", quantity: 0),
        InventoryItem(name: "Wearable PFDs", symbol: "person.fill.checkmark", quantity: 0, link: URL(string: "https://www.westmarine.com/west-marine-all-clear-offshore-inflatable-life-jacket-with-harness-20164240.html")),
        InventoryItem(name: "Throwable PFD", symbol: "lifepreserver.fill", quantity: 0, link: URL(string: "https://www.westmarine.com/jim-buoy-type-iv-ring-buoys-P008_242_002_002.html?queryID=70fd1dcecbc5bd99e37e2fa48fd9f656&objectID=171348&indexName=production_na01_westmarine_demandware_net__WestMarine__products__en_US")),
        InventoryItem(name: "Fire Extinguisher", symbol: "flame.fill", quantity: 0, link: URL(string: "https://www.westmarine.com/kidde-mariner-210-fire-extinguisher-20539573.html?queryID=f203715c432139b2dd433500f1cc8293&objectID=20539573&indexName=production_na01_westmarine_demandware_net__WestMarine__products__en_US")),
        InventoryItem(name: "Backfire Flame Arrestor", symbol: "bolt.fill", quantity: 0, link: URL(string: "https://www.westmarine.com/sierra-flame-arrestors-for-mercruiser-stern-drives-P006_180_001_502.html?queryID=ab923e91967c63618a7643ca0e556ce9&objectID=1948132&indexName=production_na01_westmarine_demandware_net__WestMarine__products__en_US")),
        InventoryItem(name: "Ventilation System", symbol: "wind", quantity: 0, link: URL(string: "https://www.westmarine.com/centek-temperature-based-automatic-engine-room-ventilation-control-system-for-ac-fans-20554242.html?queryID=c0ce44b45a6b066d00fa9033fbf95534&objectID=20554242&indexName=production_na01_westmarine_demandware_net__WestMarine__products__en_US")),
        InventoryItem(name: "Muffler", symbol: "speaker.wave.2.fill", quantity: 0, link: URL(string: "https://www.westmarine.com/centek-verna-ski-muffler-3.0inch-in-out-7441579.html?queryID=e3229f13f5c44cb5d35166052694518b&objectID=7441579&indexName=production_na01_westmarine_demandware_net__WestMarine__products__en_US")),
        InventoryItem(name: "Horn, Whistle, or Bell", symbol: "bell.fill", quantity: 0, link: URL(string: "https://www.westmarine.com/orion-hear-me-safety-whistle-2-pack-15003478.html?queryID=dadabfe687a0b406e896b9864f2cf1ab&objectID=15003478&indexName=production_na01_westmarine_demandware_net__WestMarine__products__en_US")),
        InventoryItem(name: "Daytime VDSs", symbol: "sun.max.fill", quantity: 0, link: URL(string: "https://www.westmarine.com/orion-handheld-orange-smoke-flares-3-pack-157800.html?queryID=ae78ef89d2c6f1ab78a63556f16d7bb3&objectID=157800&indexName=production_na01_westmarine_demandware_net__WestMarine__products__en_US")),
        InventoryItem(name: "Nighttime VDSs", symbol: "moon.stars.fill", quantity: 0, link: URL(string: "https://www.westmarine.com/orion-handheld-orange-smoke-flares-3-pack-157800.html?queryID=ae78ef89d2c6f1ab78a63556f16d7bb3&objectID=157800&indexName=production_na01_westmarine_demandware_net__WestMarine__products__en_US")),
        InventoryItem(name: "Navigation Lights", symbol: "lightbulb.fill", quantity: 0, link: URL(string: "https://www.westmarine.com/west-marine-deck-mount-led-navigation-lights-2-nautical-miles-visibility-20291340.html?queryID=0688f0dc2196fd9eed09e1b73a408677&objectID=20291340&indexName=production_na01_westmarine_demandware_net__WestMarine__products__en_US")),
        InventoryItem(name: "Anchor, Line, and Bailer", symbol: "aqi.medium", quantity: 0, link: URL(string: "https://www.westmarine.com/west-marine-traditional-anchor-rode-packages-P005_159_001_006.html?queryID=8b6a616be69ab3ae894a006c01b57843&objectID=11610540&indexName=production_na01_westmarine_demandware_net__WestMarine__products__en_US")),
        InventoryItem(name: "Boarding Ladder", symbol: "arrow.up.and.down.circle", quantity: 0, link: URL(string: "https://www.westmarine.com/west-marine-4-step-gunwale-mount-boarding-ladder-11inch-hook-white-steps-20009072.html?queryID=d5f38f2f4029922c70f7842d299758a2&objectID=20009072&indexName=production_na01_westmarine_demandware_net__WestMarine__products__en_US"))
    ]
}
