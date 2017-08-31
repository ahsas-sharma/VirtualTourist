//
//  PhotoAlbumCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Ahsas Sharma on 30/08/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class PhotoAlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func isImageSet() -> Bool {
        if imageView.image != nil {
            return true
        } else {
            return false
        }
    }
    
}
