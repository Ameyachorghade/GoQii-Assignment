//
//  ContentView.swift
//  GoQii Assignment
//
//  Created by Ameya Chorghade on 11/06/24.
//

import SwiftUI
import CoreData
import UserNotifications

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: WaterLog.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WaterLog.date, ascending: false)]
    ) var waterLogs: FetchedResults<WaterLog>

    @State private var isAddingWater = false
    @State private var isEditingLog = false
    @State private var selectedLog: WaterLog?

    var body: some View {
        NavigationView {
            VStack {
                HydrationRingView(totalIntake: totalDailyIntake())
                
                List {
                    ForEach(waterLogs) { log in
                        HStack {
                            Text("\(log.quantity, specifier: "%.0f") \(log.unit ?? "")")
                            Spacer()
                            Text(log.date!, style: .date)
                        }
                        .onTapGesture {
                            selectedLog = log
                            isEditingLog = true
                        }
                    }
                    .onDelete(perform: deleteLogs)
                }
                
                Button(action: {
                    isAddingWater.toggle()
                }) {
                    Text("Add Water")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .sheet(isPresented: $isAddingWater) {
                AddWaterView()
            }
            .sheet(isPresented: $isEditingLog) {
                if let log = selectedLog {
                    EditWaterView(log: log)
                }
            }
            .navigationTitle("Hydration Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: scheduleNotification) {
                        Image(systemName: "bell.fill")
                    }
                }
            }
        }
    }

    private func totalDailyIntake() -> Double {
        let todayLogs = waterLogs.filter { Calendar.current.isDateInToday($0.date!) }
        return todayLogs.reduce(0) { $0 + $1.quantity }
    }

    private func deleteLogs(offsets: IndexSet) {
        withAnimation {
            offsets.map { waterLogs[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Time to Hydrate!"
                content.body = "Remember to drink some water."
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1000, repeats: true)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                center.add(request)
            }
        }
    }
}

