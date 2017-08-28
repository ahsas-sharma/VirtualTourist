//
//  Pin+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Ahsas Sharma on 26/08/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var album: Album?
    @NSManaged public var photo: NSSet?

}

// MARK: Generated accessors for photo
extension Pin {

    @objc(addPhotoObject:)
    @NSManaged public func addToPhoto(_ value: Photo)

    @objc(removePhotoObject:)
    @NSManaged public func removeFromPhoto(_ value: Photo)

    @objc(addPhoto:)
    @NSManaged public func addToPhoto(_ values: NSSet)

    @objc(removePhoto:)
    @NSManaged public func removeFromPhoto(_ values: NSSet)

}

// MARK: MKAnnotation Protocol

extension Pin: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        let latDegrees = CLLocationDegrees(lat)
        let longDegrees = CLLocationDegrees(long)
        return CLLocationCoordinate2D(latitude: latDegrees, longitude: longDegrees)
    }
    
    public var annotation: MKPointAnnotation {
        let a = MKPointAnnotation()
        a.coordinate = self.coordinate
        return a
    }
}
