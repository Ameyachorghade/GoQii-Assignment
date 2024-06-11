//
//  EditWaterView.swift
//  GoQii Assignment
//
//  Created by Ameya Chorghade on 10/06/24.
//

import SwiftUI

struct EditWaterView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var log: WaterLog
    @State private var quantity: String = ""
    @State private var unit: String = "ml"
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Quantity", text: $quantity)
                    .keyboardType(.decimalPad)
                    .onAppear {
                        quantity = "\(log.quantity)"
                        unit = log.unit ?? "ml"
                    }
                
                Picker("Unit", selection: $unit) {
                    Text("ml").tag("ml")
                    Text("Glass").tag("glass")
                    Text("Bottle").tag("bottle")
                }
                
                Button(action: updateWaterLog) {
                    Text("Update")
                }
            }
            .navigationTitle("Edit Water Log")
        }
    }
    
    private func updateWaterLog() {
        withAnimation {
            log.quantity = Double(quantity) ?? log.quantity
            log.unit = unit
            
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


