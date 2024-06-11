//
//  AddWaterView.swift
//  GoQii Assignment
//
//  Created by Ameya Chorghade on 10/06/24.
//

import SwiftUI

struct AddWaterView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var quantity: String = ""
    @State private var unit: String = "ml"
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Quantity", text: $quantity)
                    .keyboardType(.decimalPad)
                
                Picker("Unit", selection: $unit) {
                    Text("ml").tag("ml")
                    Text("Glass").tag("glass")
                    Text("Bottle").tag("bottle")
                }
                
                Button(action: addWaterLog) {
                    Text("Add")
                }
            }
            .navigationTitle("Add Water Log")
        }
    }
    
    private func addWaterLog() {
        withAnimation {
            let newLog = WaterLog(context: viewContext)
            newLog.quantity = Double(quantity) ?? 0
            newLog.unit = unit
            newLog.date = Date()
            
            saveContext()
            presentationMode.wrappedValue.dismiss()
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
}

