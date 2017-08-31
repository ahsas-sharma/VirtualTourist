//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Ahsas Sharma on 25/08/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var selectedAnnotation: MKAnnotation!
    let delegate = UIApplication.shared.delegate as! AppDelegate

    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>?{
        didSet {
            fetchedResultsController?.delegate = self
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup item size and spacing using collection view flow layout
        let space:CGFloat = 1.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)

        // Setup navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.isHidden = false
                
        self.mapView.addAnnotation(selectedAnnotation)
        
        // Set the region to center mapview on current coordinates
        let coordinate = selectedAnnotation.coordinate
        
        // set the region
        let span = MKCoordinateSpanMake(0.500, 0.500)
        let region =  MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
        
        // Create a fetchrequest
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        fr.sortDescriptors = [NSSortDescriptor(key: "lat", ascending: true)]
        
        // Initialize the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: delegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)

    }
    
}

extension PhotoAlbumViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        
        let activityIndicator = UIActivityIndicatorView(frame: cell.contentView.bounds)
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.startAnimating()
        cell.contentView.addSubview(activityIndicator)
        
        cell.backgroundColor = .white
        return cell
    }
}

// MARK: - PhotoAlbumViewController: NSFetchedResultsControllerDelegate

extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
    
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
