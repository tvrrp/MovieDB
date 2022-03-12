//
//  CoreDataManager.swift
//  MovieDB
//
//  Created by Damir Yackupov on 11.03.2022.
//

import CoreData

final class CoreDataManager {
    
    lazy var persistantContainer: NSPersistentContainer = {
        let persistantContainer = NSPersistentContainer(name: "MovieDB")
        persistantContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return persistantContainer
    }()
    
    lazy var manObjContext: NSManagedObjectContext = {
        return persistantContainer.viewContext
    }()
    
    func saveContext(){
        let context = manObjContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
