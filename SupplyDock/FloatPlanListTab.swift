//view for all float plans, this is so that boaters can notify their loved ones when
//theyre are leaving on a journey and when their family should ask for help if theyre
//not back

import SwiftUI
import UserNotifications

struct FloatPlanListTab: View {
    @State private var plans: [FloatPlan] = []
    @State private var showForm   = false
    @State private var selected: FloatPlan?

    var body: some View {
        NavigationView {
            Group {
                if plans.isEmpty { //if there are no plans let them create one
                    VStack(spacing: 12) {
                        Text("No active Float Plans").font(.headline)
                        Button {
                            showForm = true
                        } label: {
                            Label("Create New Float Plan", systemImage: "plus")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List { //if there are plans show both
                        Section {
                            Button {
                                showForm = true
                            } label: {
                                Label("Create New Float Plan", systemImage: "plus")
                                    .font(.headline)
                            }
                        }
                        Section {
                            ForEach(plans) { plan in
                                Button {
                                    selected = plan        
                                } label: {
                                    VStack(alignment: .leading) {
                                        Text(plan.destination).bold() //used GPT for the formatting
                                        Text("Return by  \(plan.returnBy.formatted(date: .abbreviated, time: .shortened))")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Float Plans")
        }
        .sheet(isPresented: $showForm) {
            FloatPlanFormView { plan in
                plans.append(plan)
            }
        }
        .sheet(item: $selected) { plan in
            VStack(spacing: 16) {
                Text(plan.destination).font(.title2).bold()
                Text("Depart: \(plan.depart.formatted(date: .abbreviated, time: .shortened))")
                Text("Return by: \(plan.returnBy.formatted(date: .abbreviated, time: .shortened))")
                Text("Contact: \(plan.contactName) • \(plan.contactPhone)")
                Button("End Trip") {
                    UNUserNotificationCenter.current()
                        .removePendingNotificationRequests(withIdentifiers: [plan.notificationID])
                    plans.removeAll { $0.id == plan.id }
                    selected = nil
                }
                .buttonStyle(.borderedProminent)
                Spacer()
            }
            .padding()
            .presentationDetents([.medium])
        }
    }
}

#Preview { FloatPlanListTab() }
