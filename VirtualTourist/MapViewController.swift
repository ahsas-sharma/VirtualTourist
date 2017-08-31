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
    let flickrClient = FlickrClient.sharedInstance()
    
    var draggablePin : MKPointAnnotation!
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>?{
        didSet {
            fetchedResultsController?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a fetchrequest
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fr.sortDescriptors = [NSSortDescriptor(key: "lat", ascending: true)]
        
        // Initialize the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: delegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Load saved pins from the disk
        loadSavedPins()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    // MARK: - MKMapView -
    
    @IBAction func addAnnotation(_ sender: UILongPressGestureRecognizer) {
        
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

        if draggablePin != nil {
            draggablePin.coordinate = coordinate
        }
        
        if sender.state == .began {
            draggablePin = MKPointAnnotation()
            draggablePin.coordinate = coordinate
            mapView.addAnnotation(draggablePin)
        }

        if sender.state == .ended {
            draggablePin = nil

            // Fetch random page
            flickrClient.fetchImagesForCoordinates(lat: coordinate.latitude, long: coordinate.longitude, completionHandlerForFetch: {
                (result, error) in
                
                if error == nil {
                    print("Result : \(String(describing: result))")
                    
                } else {
                    print("There was an error. :\(String(describing: error))")
                }
            })
            // Create a new instance of Pin and save context
            _ = Pin(lat: coordinate.latitude, long: coordinate.longitude, context: delegate.stack.context)
            delegate.stack.save()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.isDraggable = false
            pinView!.canShowCallout = false
            pinView?.animatesDrop = true
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let photoAlbumVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotoAlbumViewController") as! PhotoAlbumViewController
        
        photoAlbumVC.selectedAnnotation = view.annotation
        
        self.navigationController?.pushViewController(photoAlbumVC, animated: true)
    }
    
    func loadSavedPins() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(String(describing: fetchedResultsController))")
            }
            
            guard let pins = fc.fetchedObjects as? [Pin] else {
                return
            }
            
            print("Pin Count: \(pins.count)")
            mapView.removeAnnotations(mapView.annotations)
            
            for pin in pins {
                mapView.addAnnotation(pin.annotation)
            }
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
    }
}


