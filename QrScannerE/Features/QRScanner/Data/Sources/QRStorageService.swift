//
//  QRScannerView.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import CoreData

protocol QRStorageServiceProtocol {
    func save(code: QRCode) throws
    func fetchAll() throws -> [QRCode]
    func delete(code: QRCode) throws
}

final class QRStorageService: QRStorageServiceProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.context = context
    }
    
    func save(code: QRCode) throws {
        let entity = QRCodeEntity(context: context)
        entity.id = code.id
        entity.content = code.content
        entity.scanDate = code.scanDate
        
        try context.save()
    }
    
    func fetchAll() throws -> [QRCode] {
        let request: NSFetchRequest<QRCodeEntity> = QRCodeEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "scanDate", ascending: false)]
        
        return try context.fetch(request).map {
            QRCode(id: $0.id ?? UUID(),
                   content: $0.content ?? "",
                   scanDate: $0.scanDate ?? Date())
        }
    }
    
    func delete(code: QRCode) throws {
        let request: NSFetchRequest<QRCodeEntity> = QRCodeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", code.id as CVarArg)
        
        if let entity = try context.fetch(request).first {
            context.delete(entity)
            try context.save()
        }
    }
}

// Core Data Stack
final class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "QRScannerModel")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Core Data Error: \(error), \(error.userInfo)")
            }
            print("SQLite Location: \(storeDescription.url?.absoluteString ?? "")")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
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
