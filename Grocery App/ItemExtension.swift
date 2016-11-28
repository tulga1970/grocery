//
//  MyData+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Downey, Eric on 11/25/16.
//  Copyright © 2016 Eric Downey. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }
    
    @NSManaged public var isComplete: Bool
    @NSManaged public var quantityType: String?
    @NSManaged public var name: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var grocery: Grocery?
    
}
