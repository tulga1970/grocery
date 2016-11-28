//
//  Collection+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Downey, Eric on 11/25/16.
//  Copyright © 2016 Eric Downey. All rights reserved.
//

import Foundation
import CoreData

extension Grocery {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grocery> {
        return NSFetchRequest<Grocery>(entityName: "Grocery");
    }
    
    @NSManaged public var name: String?
    @NSManaged public var isComplete: Bool
    @NSManaged public var items: NSSet?
    
}

extension Grocery {
    
    @objc(addPeopleObject:)
    @NSManaged public func addToItems(_ value: Item)
    
    @objc(removePeopleObject:)
    @NSManaged public func removeFromItems(_ value: Item)
    
    @objc(addPeople:)
    @NSManaged public func addToItems(_ values: NSSet)
    
    @objc(removePeople:)
    @NSManaged public func removeFromItems(_ values: NSSet)
    
}
