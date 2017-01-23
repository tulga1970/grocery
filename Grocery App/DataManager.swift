//
//  DataManager.swift
//  CoreDataTest
//
//  Created by Downey, Eric on 11/21/16.
//  Copyright © 2016 Eric Downey. All rights reserved.
//

import CoreData

enum DataError: Error {
    case BadManagedObjectContext(String)
    case BadEntity(String)
}

class DataManager {
    static var shared: DataManager = DataManager()
    
    var managedObjectContext: NSManagedObjectContext?
    
    var groceries: [Grocery]
    var groceryCount: Int {
        return groceries.count
    }
    
    var items: [Item]
    var myDataCount: Int {
        return items.count
    }
    
    var selectedGroceryIndex: Int
    var selectedItemIndex: Int
    
    private init() {
        groceries = []
        items = []
        selectedGroceryIndex = -1
        selectedItemIndex = -1
    }
}

extension DataManager {
    func loadGroceries() {
        groceries = fetch()
    }
    
    func create(grocery name: String?) throws {
        guard let ctx = managedObjectContext else {
            throw DataError.BadManagedObjectContext("The managed object context was nil")
        }
        guard let entity = NSEntityDescription.entity(forEntityName: "Grocery", in: ctx) else {
            throw DataError.BadEntity("The entity description was bad")
        }
        let obj = Grocery(entity: entity, insertInto: ctx)
        obj.name = name
        obj.isComplete = false
        
        do {
            try save()
        }catch {
            print(error)
        }
    }
    
    func getGrocery(from indexPath: IndexPath) -> (name: String?, itemCount: Int?)? {
        guard let grocery = groceries.value(at: indexPath.row) else {
            return nil
        }
        
        return (grocery.name, (grocery.items?.count))
    }
}

extension DataManager {
    // MARK: - Get / Create New MyData
    func loadItems() {
        let selectedGrocery = groceries.value(at: selectedGroceryIndex)
        items = selectedGrocery?.items?.flatMap { item in
            return item as? Item
            } ?? []
    }
    
    func createOrSave(data: (name: String?, quantityType: String?, quantity: Int)) throws {
        guard let ctx = managedObjectContext else {
            throw DataError.BadManagedObjectContext("The managed object context was nil")
        }
        guard let entity = NSEntityDescription.entity(forEntityName: "Item", in: ctx) else {
            throw DataError.BadEntity("The entity description was bad")
        }
        
        let item = items.value(at: selectedItemIndex)
        if (item == nil) {
            let obj = Item(entity: entity, insertInto: ctx)
            obj.name = data.name
            obj.quantity = Int16(data.quantity)
            obj.quantityType = data.quantityType
            obj.grocery = groceries.value(at: selectedGroceryIndex)
            obj.isComplete = false
        } else {
            item?.name = data.name
            item?.quantity = Int16(data.quantity)
            item?.quantityType = data.quantityType
            item?.grocery = groceries.value(at: selectedGroceryIndex)
            item?.isComplete = false
        }
        
        selectedItemIndex = -1
        
        try? save()
    }
    
    func deleteItem() throws {
        guard let ctx = managedObjectContext else {
            throw DataError.BadManagedObjectContext("The managed object context was nil")
        }
        
        ctx.delete(items[selectedItemIndex])
        items.remove(at: selectedItemIndex)
        
        try? save()

    }
    
    func deleteGrocery() throws {
        guard let ctx = managedObjectContext else {
            throw DataError.BadManagedObjectContext("The managed object context was nil")
        }
        
        for item in groceries[selectedGroceryIndex].items! {
            if let it = (item as? Item) {
                ctx.delete(it)
            }
        }
        
        ctx.delete(groceries[selectedGroceryIndex])
        groceries.remove(at: selectedGroceryIndex)
        
        try? save()
        
    }
    
    func getItem(from row: Int) -> (name: String?, quantityType: String?, quantity: Int16, isComplete: Bool)? {
        guard let item = items.value(at: row) else {
            return nil
        }
        
        return (item.name, item.quantityType, Int16(item.quantity), item.isComplete)
    }
    
    func getSelectedItem() -> (name: String?, quantityType: String?, quantity: Int16, isComplete: Bool)? {
        guard let item = items.value(at: selectedItemIndex) else {
            return nil
        }
        return (item.name, item.quantityType, Int16(item.quantity), item.isComplete)
    }
}

extension DataManager {
    // MARK: - Fetching Data
    
    func fetch<T: NSManagedObject>() -> [T] {
        var result: [T]? = nil
        managedObjectContext?.performAndWait { [weak self] in
            do {
                result = try self?.executeFetchRequest()
            }
            catch {
                print(error)
            }
        }
        return result ?? []
    }
    
    private func executeFetchRequest<T: NSManagedObject>() throws -> [T]? {
        let request = T.fetchRequest()
        
        return try request.execute() as? [T]
    }
    
    func save() throws {
        try managedObjectContext?.save()
    }
}
