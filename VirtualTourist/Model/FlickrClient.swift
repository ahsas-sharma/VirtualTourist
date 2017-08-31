//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Ahsas Sharma on 28/08/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import Foundation

class FlickrClient: NSObject {
    
    // MARK:- Properties
    
    // Store shared URLSession
    var session = URLSession.shared
    typealias handler = (_ result: AnyObject?, _ error: NSError?) -> Void
    
    // Shared FlickrClient instance
    class func sharedInstance() -> FlickrClient {
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        return Singleton.sharedInstance
    }
    
    func fetchImagesForCoordinates(lat: Double, long: Double, completionHandlerForFetch: @escaping handler) {
        
        // Add the bounding box key and value to method parameters
        var methodParameters = Constants.Flickr.staticParameters as [String: AnyObject]
        methodParameters[Constants.FlickrParameterKeys.boundingBox] = boundingBoxStringForCoordinate(lat: lat, long: long)
        
        // create the request
        let request = URLRequest(url: urlFromParameters(methodParameters))
        
        // create the task
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // parse the result or return errors
            self.parseResultIntoPhotosDictionary(data: data, response: response, error: error, completionHandlerForParseResult: { (photosDictionary, error) in
                
                guard error == nil else {
                    completionHandlerForFetch(nil, error)
                    return
                }
                
                let photosDictionary = photosDictionary as! [String: AnyObject]
                
                /* GUARD: Is "pages" key in the photosDictionary? */
                guard let totalPages = photosDictionary[Constants.FlickrResponseKeys.pages] as? Int else {
                    print("Cannot find key '\(Constants.FlickrResponseKeys.pages)' in \(photosDictionary)")
                    return
                }
                
                // pick a random page!
                let pageLimit = min(totalPages, 40)
                let randomPage = Int(arc4random_uniform(UInt32(pageLimit))) + 1
                
                print("Total Pages: \(totalPages)")
                print("Random Page: \(randomPage)")
                
                self.fetchImagesForPageNumber(randomPage, parameters: methodParameters, completionHandlerForFetchPage: {
                    (result, error) in
                    
                    guard error == nil else {
                        completionHandlerForFetch(nil, error)
                        return
                    }
                    completionHandlerForFetch(result, nil)
                })
            })
        }
        
        task.resume()
        
        
    }
    
    private func fetchImagesForPageNumber(_ page: Int, parameters: [String: AnyObject], completionHandlerForFetchPage: @escaping handler) {
        
        // Add the page key and value to method parameters
        var methodParameters = parameters
        methodParameters[Constants.FlickrParameterKeys.page] = page as AnyObject
        
        // create the request
        let request = URLRequest(url: urlFromParameters(methodParameters))
        
        // create the task
        let task = session.dataTask(with: request) { (data, response, error) in
            
            self.parseResultIntoPhotosDictionary(data: data, response: response, error: error, completionHandlerForParseResult: {
                (photosDictionary, error) in
                
                guard error == nil else {
                    return
                }
                
                let photosDictionary = photosDictionary as! [String: AnyObject]
                
                /* GUARD: Is the "photo" key in photosDictionary? */
                guard let photosArray = photosDictionary[Constants.FlickrResponseKeys.photo] as? [[String: AnyObject]] else {
                    print("Cannot find key '\(Constants.FlickrResponseKeys.photo)' in \(photosDictionary)")
                    return
                }
                
                if photosArray.count == 0 {
                    print("No Photos Found. Search Again.")
                    return
                } else {
                    var photoUrlsArray = [String]()
                    for photo in photosArray {
                        guard let imageUrlString = photo[Constants.FlickrResponseKeys.mediumURL] as? String else {
                            print("Cannot find key '\(Constants.FlickrResponseKeys.mediumURL)' in \(photo)")
                            return
                        }
                        photoUrlsArray.append(imageUrlString)
                    }
                    
                    completionHandlerForFetchPage(photoUrlsArray as AnyObject, nil)
                }
            })
        }
        // start the task!
        task.resume()
    }
    
    
    private func urlFromParameters(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Flickr.apiScheme
        components.host = Constants.Flickr.apiHost
        components.path = Constants.Flickr.apiPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        print("URL: \(String(describing: components.url?.absoluteString))")
        return components.url!
    }
    
    private func boundingBoxStringForCoordinate(lat: Double, long: Double) -> AnyObject {
        // ensure bbox is bounded by minimum and maximums
        
        let minimumLon = max(long - Constants.Flickr.searchBBoxHalfWidth, Constants.Flickr.searchLonRange.0)
        let minimumLat = max(lat - Constants.Flickr.searchBBoxHalfHeight, Constants.Flickr.searchLatRange.0)
        let maximumLon = min(long + Constants.Flickr.searchBBoxHalfWidth, Constants.Flickr.searchLonRange.1)
        let maximumLat = min(lat + Constants.Flickr.searchBBoxHalfHeight, Constants.Flickr.searchLatRange.1)
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)" as AnyObject
        
    }
    
    private func parseResultIntoPhotosDictionary(data: Data?, response: AnyObject?, error: Error?, completionHandlerForParseResult: handler) {
        
        // Check if there was an error
        guard (error == nil) else {
            let error = error! as NSError
            self.sendError("There was an error with the data task. Error: \(String(describing: error)) ", code: error.code, domain: error.domain, completionHandler: completionHandlerForParseResult)
            return
        }
        
        // Check if we got a successfull 2XX response
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            let errorCode = ((response as? HTTPURLResponse)?.statusCode)!
            self.sendError("Your request returned a status code other than 2xx!. Code: \(errorCode)", code: errorCode, domain: "completionHandlerForParseResult", completionHandler: completionHandlerForParseResult)
            return
        }
        
        
        /* GUARD: Was there any data returned? */
        guard let data = data else {
            self.sendError("No data was returned by the request!", code: 404, domain: "completionHandlerForParseResult", completionHandler: completionHandlerForParseResult)
            return
        }
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Unable to parse the following data as JSON: '\(data)'"]
            completionHandlerForParseResult(nil, NSError(domain: "completionHandlerForParseResult", code: 1, userInfo: userInfo))
        }
        
        guard let stat = parsedResult?[Constants.FlickrResponseKeys.status] as? String, stat == Constants.FlickrResponseValues.oKStatus else {
            
            self.sendError("Flickr API returned an error. See error code and message in : \(String(describing: error)) ", code: 400, domain: "FlickStatError", completionHandler: completionHandlerForParseResult)
            
            return
        }
        
        /* GUARD: Is "photos" key in our result? */
        guard let photosDictionary = parsedResult?[Constants.FlickrResponseKeys.photos] as? [String:AnyObject] else {
            self.sendError("Cannot find photos key in the response. \(String(describing: parsedResult)) ", code: 404, domain: "FlickrPhotosKeyError", completionHandler: completionHandlerForParseResult)
            return
        }
        
        
        completionHandlerForParseResult(photosDictionary as AnyObject, nil)
        
    }
    
    
    // send error for domain
    private func sendError(_ error: String, code: Int, domain: String, completionHandler: handler) {
        debugPrint("###### Sending Error String: \(error), Code : \(code)")
        let userInfo = [NSLocalizedDescriptionKey : error]
        completionHandler(nil, NSError(domain: domain, code: code, userInfo: userInfo))
    }
}
