//
//  PersistenceController.swift
//  GoQii Assignment
//
//  Created by Ameya Chorghade on 11/06/24.
//

import CoreData

struct Persistencecontroller {
    // Singleton instance 
    static let shared = PersistenceController()

        static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Add some sample data for previewing
        for _ in 0..<10 {
            let newLog = WaterLog(context: viewContext)
            newLog.date = Date()
            newLog.quantity = Double.random(in: 200...500)
            newLog.unit = "ml"
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()

 
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GoQii_Assignment")

        if inMemory {
            
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        // Load the persistent stores
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        // Configure context behavior
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // Method to save the current state of the context
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


