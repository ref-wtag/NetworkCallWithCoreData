//
//  Products+CoreDataProperties.swift
//  NetworkCallWithCoreData
//
//  Created by Refat E Ferdous on 12/5/23.
//
//

import Foundation
import CoreData


extension Products {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Products> {
        return NSFetchRequest<Products>(entityName: "Products")
    }

    @NSManaged public var title: String?
    @NSManaged public var price: Double
    @NSManaged public var descrip: String?
    @NSManaged public var category: String?
    @NSManaged public var image: String?
    @NSManaged public var rate: Double
    @NSManaged public var count: Double

}

extension Products : Identifiable {

}
