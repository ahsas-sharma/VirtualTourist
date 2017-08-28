//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Ahsas Sharma on 25/08/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Properties
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var annotations = [MKPointAnnotation]()
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>?{
        didSet {
            fetchedResultsController?.delegate = self
            print("didSet fetchedResultsController")
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a fetchrequest
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fr.sortDescriptors = [NSSortDescriptor(key: "lat", ascending: true)]
        
        // Create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: delegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        updateAnnotations()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    // MARK: - MKMapView -
    
    
    @IBAction func addAnnotation(_ sender: UILongPressGestureRecognizer) {

        if sender.state == .began {
            print("sender state is .began")
            let point = sender.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            _ = Pin(lat: coordinate.latitude, long: coordinate.longitude, context: delegate.stack.context)
            delegate.stack.save()
            updateAnnotations()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Did Select AnnotationView: \(String(describing: view.annotation?.coordinate))")
        
        let photoAlbumVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotoAlbumViewController") as! PhotoAlbumViewController
        
        photoAlbumVC.coordinates = view.annotation?.coordinate
        photoAlbumVC.annotation = view.annotation
        
        self.navigationController?.pushViewController(photoAlbumVC, animated: true)
    }
    
    func updateAnnotations() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(String(describing: fetchedResultsController))")
            }
            
            guard let pins = fc.fetchedObjects as? [Pin] else {
                return
            }
            
            print("Count: \(pins.count)")
            
            self.mapView.removeAnnotations(self.annotations)
            annotations.removeAll()
            
            for pin in pins {
                self.annotations.append(pin.annotation)
            }
            
            mapView.addAnnotations(annotations)
        }
    }

}

// MARK: - CoreDataTableViewController: NSFetchedResultsControllerDelegate

extension MapViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        debugPrint("====== NSFetchedResultController willChangeContent ======")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        debugPrint("====== NSFetchedResultController didChange anObject ======")
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        debugPrint("====== NSFetchedResultController didChangeContent ======")
//        updateAnnotations()
    }
}


