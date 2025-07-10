import SwiftUI
import UserNotifications
import MessageUI

struct FloatPlan: Identifiable, Equatable {
    let id = UUID()
    var destination:    String
    var contactName:    String
    var contactPhone:   String
    var depart:  Date
    var returnBy: Date
    var notificationID: String
}

struct MessageCompose: UIViewControllerRepresentable { //used chatGPT to understand how to open and send a messge through messaging app, wanted to initially create it automatic however, that reuqired IOS permission too complicated
    let recipients: [String]
    let body: String
    var finished: () -> Void = { }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        let parent: MessageCompose
        init(_ p: MessageCompose) { parent = p }
        func messageComposeViewController(
            _ vc: MFMessageComposeViewController,
            didFinishWith result: MessageComposeResult
        ) {
            vc.dismiss(animated: true) { self.parent.finished() }
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.messageComposeDelegate = context.coordinator
        vc.recipients = recipients
        vc.body = body
        return vc
    }
    func updateUIViewController(_ vc: MFMessageComposeViewController, context: Context) {}
}

struct FloatPlanFormView: View {
    @State private var departDate   = Date()
    @State private var returnDate   = Calendar.current.date(byAdding: .hour, value: 4, to: Date())!
    @State private var destination  = ""
    @State private var contactName  = ""
    @State private var contactPhone = ""
    @State private var showSheet = false
    @State private var smsBody   = ""
    @Environment(\.dismiss) private var dismiss
    var onSave: (FloatPlan) -> Void

    var body: some View {
        NavigationView {
            Form { //form for creating the plan
                Section("Trip") {
                    DatePicker("Depart",
                               selection: $departDate,
                               displayedComponents: [.date, .hourAndMinute])

                    DatePicker("Return by",
                               selection: $returnDate,
                               in: departDate...,
                               displayedComponents: [.date, .hourAndMinute])

                    TextField("Destination (lake, harbor…)", text: $destination)
                }

                Section("Emergency contact") {
                    TextField("Name",  text: $contactName)
                    TextField("Phone", text: $contactPhone)
                        .keyboardType(.phonePad)
                }

                Section {
                    Button("Start Trip") { startTrip() }
                        .disabled(destination.isEmpty || contactName.isEmpty)
                }
            }
            .navigationTitle("New Float Plan")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .sheet(isPresented: $showSheet) {
                if MFMessageComposeViewController.canSendText() {
                    MessageCompose(
                        recipients: [contactPhone],
                        body: smsBody,
                        finished: { dismiss() }
                    )
                } else {
                    fallbackCopyView
                }
            }
        }
    }

    private func startTrip() { //needed help with scheduleReminder and learning how to send notification
        let notifID = UUID().uuidString
        scheduleReminder(id: notifID)

        smsBody =
        """
        Float Plan 🚤
        Departing \(departDate.formatted(date: .abbreviated, time: .shortened)) to \(destination).
        If you don’t hear from me by \(returnDate.formatted(date: .abbreviated, time: .shortened)), please contact authorities.
        """

        showSheet = true

        onSave(FloatPlan(destination: destination,
                         contactName: contactName,
                         contactPhone: contactPhone,
                         depart: departDate,
                         returnBy: returnDate,
                         notificationID: notifID))
    }

    private func scheduleReminder(id: String) { //send reminder when the time comes
        let content = UNMutableNotificationContent()
        content.title = "Float Plan: Check-in missed"
        content.body  = "Contact \(contactName) at \(contactPhone)"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: max(5, returnDate.timeIntervalSinceNow),
            repeats: false)

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { ok, _ in
            guard ok else { return }
            UNUserNotificationCenter.current()
                .add(.init(identifier: id, content: content, trigger: trigger))
        }
    }

    private var fallbackCopyView: some View { //in case its run on the simlulator and can't send a text message it'll show a message
        VStack(spacing: 16) {
            Text("This device can’t send SMS.")
                .font(.headline)
                .multilineTextAlignment(.center)

            Text("Please copy the message below and send it to \(contactName) manually.")
                .multilineTextAlignment(.center)

            ScrollView {
                Text(smsBody)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .frame(maxHeight: 200)

            Button("Done") { dismiss() }
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview("Float Plan Form") {
    FloatPlanFormView { _ in }
        .previewDevice("iPhone 15")
}
