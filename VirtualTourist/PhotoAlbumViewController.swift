//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Ahsas Sharma on 25/08/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotation: MKAnnotation!
    var coordinates : CLLocationCoordinate2D!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.isHidden = false
                
        self.mapView.addAnnotation(annotation)
        
        // Set the region to center mapview on current coordinates
        if let coordinates = coordinates {
            // set the region
            let span = MKCoordinateSpanMake(0.500, 0.500)
            let region =  MKCoordinateRegion(center: coordinates, span: span)
            self.mapView.setRegion(region, animated: true)
            
            
        }
        
    }

    
}
