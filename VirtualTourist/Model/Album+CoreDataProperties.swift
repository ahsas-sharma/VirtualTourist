//
//  Album+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Ahsas Sharma on 26/08/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var photo: NSSet?
    @NSManaged public var pin: Pin?

}

// MARK: Generated accessors for photo
extension Album {

    @objc(addPhotoObject:)
    @NSManaged public func addToPhoto(_ value: Photo)

    @objc(removePhotoObject:)
    @NSManaged public func removeFromPhoto(_ value: Photo)

    @objc(addPhoto:)
    @NSManaged public func addToPhoto(_ values: NSSet)

    @objc(removePhoto:)
    @NSManaged public func removeFromPhoto(_ values: NSSet)

}
