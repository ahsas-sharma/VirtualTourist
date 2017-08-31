//
//  Constants.swift
//  VirtualTourist
//
//  Created by Ahsas Sharma on 28/08/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import Foundation

struct Constants {
    
    // MARK: Flickr
    struct Flickr {
        static let apiScheme = "https"
        static let apiHost = "api.flickr.com"
        static let apiPath = "/services/rest"
        
        static let staticParameters = [
            FlickrParameterKeys.method : FlickrParameterValues.searchMethod,
            FlickrParameterKeys.apiKey: FlickrParameterValues.apiKey,
            FlickrParameterKeys.safeSearch: FlickrParameterValues.useSafeSearch,
            FlickrParameterKeys.extras: FlickrParameterValues.mediumURL,
            FlickrParameterKeys.format: FlickrParameterValues.responseFormat,
            FlickrParameterKeys.noJSONCallback: FlickrParameterValues.disableJSONCallback
        ]
        
        // Bounding Box
        static let searchBBoxHalfWidth = 1.0
        static let searchBBoxHalfHeight = 1.0
        static let searchLatRange = (-90.0, 90.0)
        static let searchLonRange = (-180.0, 180.0)
    }
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let method = "method"
        static let apiKey = "api_key"
        static let boundingBox = "bbox"
        static let extras = "extras"
        static let format = "format"
        static let noJSONCallback = "nojsoncallback"
        static let safeSearch = "safe_search"
        static let text = "text"
        static let page = "page"
    }
    
    // MARK: Flickr Parameter Values
    struct FlickrParameterValues {
        static let searchMethod = "flickr.photos.search"
        static let apiKey = "d94c02d2f989b42805d54a377ec79fbd"
        static let responseFormat = "json"
        static let disableJSONCallback = "1"
        static let mediumURL = "url_m"
        static let useSafeSearch = "1"
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let status = "stat"
        static let photos = "photos"
        static let photo = "photo"
        static let title = "title"
        static let mediumURL = "url_m"
        static let pages = "pages"
        static let total = "total"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let oKStatus = "ok"
    }
    
   
}
