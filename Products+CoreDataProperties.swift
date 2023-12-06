//
//  Products+CoreDataProperties.swift
//  NetworkCallWithCoreData
//
//  Created by Refat E Ferdous on 12/6/23.
//
//

import Foundation
import CoreData


extension Products {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Products> {
        return NSFetchRequest<Products>(entityName: "Products")
    }

    @NSManaged public var category: String?
    @NSManaged public var count: Int16
    @NSManaged public var descrip: String?
    @NSManaged public var image: String?
    @NSManaged public var price: Double
    @NSManaged public var rate: Double
    @NSManaged public var title: String?
    @NSManaged public var pId: Int16

}

extension Products : Identifiable {

}
