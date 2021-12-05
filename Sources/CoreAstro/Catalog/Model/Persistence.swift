//
//  Persistence.swift
//  Shared
//
//  Created by Don Willems on 01/12/2021.
//

import CoreData

struct CatalogPersistenceController {
    static let shared = CatalogPersistenceController()
    
    func createCatalog(catalog: Catalog) throws -> UMCatalog {
        let umcatalog = try self.createCatalog(abbreviation: catalog.abbreviation)
        if umcatalog.name == nil {
            umcatalog.name = catalog.name
            try self.container.viewContext.save()
        }
        return umcatalog
    }
    
    private func createCatalog(abbreviation: String) throws -> UMCatalog {
        var umcatalog = try self.umCatalog(abbreviation: abbreviation)
        if umcatalog != nil {
            return umcatalog!
        }
        umcatalog = UMCatalog(context: self.container.viewContext)
        umcatalog!.abbreviation = abbreviation
        return umcatalog!
    }
    
    public func catalogHasBeenImported(abbreviation: String) throws -> Bool {
        let umcatalog = try self.umCatalog(abbreviation: abbreviation)
        return umcatalog != nil
    }
    
    private func umCatalog(abbreviation: String) throws -> UMCatalog? {
        let fetchRequest = UMCatalog.fetchRequest()
        fetchRequest.fetchLimit = 1
        return try self.container.viewContext.fetch(fetchRequest).first
    }
    
    public func search(string: String) -> [CatalogObject] {
        var results = [CatalogObject]()
        let fetchRequest = UMCelestialObject.fetchRequest()

        fetchRequest.predicate = NSPredicate(
            format: "names.name CONTAINS[cd] %@", string
        )
        let sortDescriptor = NSSortDescriptor(key: "magnitude", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let umobjects = try? self.container.viewContext.fetch(fetchRequest)
        if umobjects != nil {
            for umobject in umobjects! {
                let object = catalogObject(from: umobject)
                if object != nil {
                    results.append(object!)
                }
            }
        }
        return results
    }
    
    public func search(minRA: Double, maxRA: Double, minDec: Double, maxDec: Double) -> [CatalogObject]  {
        var results = [CatalogObject]()
        let fetchRequest = UMCelestialObject.fetchRequest()

        let minRAPredicate = NSPredicate(
            format: "rightAscension >= %f", minRA
        )

        let maxRAPredicate = NSPredicate(
            format: "rightAscension <= %f", maxRA
        )
        let minDECPredicate = NSPredicate(
            format: "declination >= %f", minDec
        )

        let maxDECPredicate = NSPredicate(
            format: "declination <= %f", maxDec
        )
        var RAPredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                minRAPredicate,
                maxRAPredicate
            ]
        )
        if maxRA < minRA { // RA spans over 0h
            RAPredicate = NSCompoundPredicate(
                orPredicateWithSubpredicates: [
                    minRAPredicate,
                    maxRAPredicate
                ]
            )
        }
        let DECPredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                minDECPredicate,
                maxDECPredicate
            ]
        )
        fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                RAPredicate,
                DECPredicate
            ]
        )
        let sortDescriptor = NSSortDescriptor(key: "magnitude", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let umobjects = try? self.container.viewContext.fetch(fetchRequest)
        if umobjects != nil {
            for umobject in umobjects! {
                let object = catalogObject(from: umobject)
                if object != nil {
                    results.append(object!)
                }
            }
        }
        return results
    }
    
    private func catalogObject(from umobject: UMCelestialObject) -> CatalogObject? {
        return umobject.catalogObject
    }
    
    func addObjects(_ objects: [CatalogObject]) throws {
        print("\n-- Start Adding \(objects.count) objects from catalog")
        var i = 0
        var display = -1
        for object in objects {
            try self.addObject(object)
            i = i+1
            if Int(i/(objects.count/100)) != display {
                display = Int(i/(objects.count/100))
                print("\t\(display)% Done")
            }
            if i%500 == 0 {
                print("Saving objects to database")
                try self.container.viewContext.save()
            }
        }
        try self.container.viewContext.save()
    }
    
    private func addObject(_ object: CatalogObject) throws {
        let umobject = UMCelestialObject(context: self.container.viewContext)
        for type in object.types {
            let umtype = UMType(context: self.container.viewContext)
            umtype.name = type.rawValue
            umobject.addToTypes(umtype)
        }
        for name in object.names {
            let umname = UMName(context: self.container.viewContext)
            umname.name = name.string
            umname.language = name.language
            umobject.addToNames(umname)
        }
        for identifier in object.identifiers {
            let umidentifier = UMIdentifier(context: self.container.viewContext)
            umidentifier.identifier = identifier.identifier
            umidentifier.catalog = try umCatalog(abbreviation: identifier.catalogIdentifier)
            self.add(name: identifier.description, to: umobject, type: "CatalogIdentifier")
            umobject.addToIdentifiers(umidentifier)
        }
        let eqJ2000 = object.equatorialCoordinates(on: .J2000)
        umobject.rightAscension = try! eqJ2000.longitude.convert(to: .degree).scalarValue
        umobject.declination = try! eqJ2000.latitude.convert(to: .degree).scalarValue
        if (object as? CatalogStar) != nil {
            let star = object as! CatalogStar
            if star.bayerDesignation != nil {
                let umdesignation = UMObjectDesignation(context: self.container.viewContext)
                umdesignation.bayer = star.bayerDesignation!.letter
                if star.bayerDesignation!.superScript != nil {
                    umdesignation.bayerSuperScript = Int16(star.bayerDesignation!.superScript!)
                }
                umdesignation.constellationAbbreviation = star.bayerDesignation!.constellation.abbreviation
                self.add(name: star.bayerDesignation!.designation, to: umobject, type:"BayerDesignation")
                self.add(name: star.bayerDesignation!.abbreviated, to: umobject, type:"BayerDesignationAbbreviated")
                self.add(name: star.bayerDesignation!.transcibed, to: umobject, type:"BayerDesignationTranscribed")
                umobject.addToDesignations(umdesignation)
            }
            if star.flamsteedDesignation != nil {
                let umdesignation = UMObjectDesignation(context: self.container.viewContext)
                umdesignation.flamsteed = Int16(star.flamsteedDesignation!.number)
                umdesignation.constellationAbbreviation = star.flamsteedDesignation!.constellation.abbreviation
                self.add(name: star.flamsteedDesignation!.designation, to: umobject, type:"FlamsteedDesignation")
                self.add(name: star.flamsteedDesignation!.abbreviated, to: umobject, type:"FlamsteedDesignationAbbreviated")
                umobject.addToDesignations(umdesignation)
            }
            if star.variableStarDesignation != nil {
                let umdesignation = UMObjectDesignation(context: self.container.viewContext)
                umdesignation.variableStar = star.variableStarDesignation!.identifier
                umdesignation.constellationAbbreviation = star.variableStarDesignation!.constellation.abbreviation
                self.add(name: star.variableStarDesignation!.designation, to: umobject, type:"VariableStarDesignation")
                self.add(name: star.variableStarDesignation!.abbreviated, to: umobject, type:"VariableStarDesignationAbbreviated")
                umobject.addToDesignations(umdesignation)
            }
            umobject.magnitude = star.magnitude.scalarValue
        }
    }
    
    private func add(name: String, to object: UMCelestialObject, type: String) {
        let umname = UMName(context: self.container.viewContext)
        umname.name = name
        umname.language = type
        object.addToNames(umname)
    }
    
    

    static var preview: CatalogPersistenceController = {
        let result = CatalogPersistenceController(inMemory: true)
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
