//
//  Pin+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Ahsas Sharma on 26/08/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import Foundation
import CoreData

@objc(Pin)
public class Pin: NSManagedObject {
    
    // MARK:- Initializer -
    
    convenience init(lat: Double, long: Double, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
            self.init(entity: ent, insertInto: context)
            self.lat = lat
            self.long = long
        } else {
            fatalError("Unable to find entity name : Pin")
        }
    }
    
    

}
