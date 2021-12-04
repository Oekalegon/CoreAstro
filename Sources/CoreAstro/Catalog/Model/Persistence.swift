//
//  Persistence.swift
//  Shared
//
//  Created by Don Willems on 01/12/2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    func createCatalog(catalog: Catalog) throws {
        if try self.umCatalog(abbreviation: catalog.abbreviation) != nil {
            return
        }
        let umcatalog = UMCatalog(context: self.container.viewContext)
        umcatalog.name = catalog.name
        umcatalog.abbreviation = catalog.abbreviation
        try self.container.viewContext.save()
    }
    
    private func umCatalog(abbreviation: String) throws -> UMCatalog? {
        let fetchRequest = UMCatalog.fetchRequest()
        fetchRequest.fetchLimit = 1
        return try self.container.viewContext.fetch(fetchRequest).first
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        /*
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
         */
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let bundle = Bundle.module
        let modelURL = bundle.url(forResource: "Catalog", withExtension: ".momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        container = NSPersistentContainer(name: "Catalog", managedObjectModel: model)
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        print("Core Data store: \(NSPersistentContainer.defaultDirectoryURL())")
    }
}
