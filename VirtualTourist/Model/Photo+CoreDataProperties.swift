//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Ahsas Sharma on 26/08/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var album: Album?
    @NSManaged public var pin: Pin?

}
