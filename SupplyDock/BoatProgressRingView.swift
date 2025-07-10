import SwiftUI
import UserNotifications

extension BoatProfile {
    var completeness: Double { //finds the percentage of profiles thats filled
        let strings: [String] = [
            name, make, model, year, type, length,
            beam, depth, material, fuel, tankVolume,
            propulsion, horsepower, engineHours,
            registrationState, registrationNumber, hin,
            expirationDate, issueDate,
            mainBodyOfWater, activities, averageRiders
        ]
        let stringFilled = strings
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .count

        let boolFilled = [
            tankPermanentlyInstalled,
            trailer,
            marina
        ].filter { $0 }.count

        let totalFields  = strings.count + 3
        let filledFields = stringFilled + boolFilled

        return Double(filledFields) / Double(totalFields)
    }
}

struct BoatProgressRingView: View { //adds the ring around the boat sumbol
    let profile: BoatProfile
    private let lineWidth: CGFloat = 10

    var body: some View {
        TimelineView(.animation) { _ in
            let progress = profile.completeness

            Canvas { context, size in
                let radius = min(size.width, size.height) / 2 - lineWidth / 2
                let center = CGPoint(x: size.width / 2, y: size.height / 2)

                var bg = Path() //asked chatgpt to help with filling the ring according to the percentage
                bg.addArc(center: center,
                          radius: radius,
                          startAngle: .degrees(0),
                          endAngle: .degrees(360),
                          clockwise: false)
                context.stroke(bg,
                               with: .color(.gray.opacity(0.2)),
                               lineWidth: lineWidth)

                var fg = Path()
                fg.addArc(center: center,
                          radius: radius,
                          startAngle: .degrees(-90),
                          endAngle: .degrees(progress * 360 - 90),
                          clockwise: false)
                context.stroke(
                    fg,
                    with: .color(.blue),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
            }
        }
        .overlay {
            Image(systemName: "ferry.fill")
                .resizable()
                .scaledToFit()
                .padding(30)
                .foregroundColor(.blue)
        }
        .frame(width: 200, height: 200)
        .animation(.easeInOut(duration: 0.6),
                   value: profile.completeness)
    }
}
