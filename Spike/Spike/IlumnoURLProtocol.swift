//
//  IlumnoURLProtocol.swift
//  Spike
//
//  Created by Jose Torres Cardenas on 4/02/16.
//  Copyright © 2016 santex. All rights reserved.
//

import UIKit
import CoreData

var requestCount = 0

class IlumnoURLProtocol: NSURLProtocol {
    
    var connection: NSURLConnection!
    var mutableData : NSMutableData!
    var response: NSURLResponse!
    
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        print("Request #\(requestCount++): \(request.URL!.absoluteString)")
        if NSURLProtocol.propertyForKey("IlumnoURLProtocolHandleKey", inRequest: request) != nil {
            return false
        }
        return true
    }

    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(aRequest: NSURLRequest, toRequest bRequest: NSURLRequest) -> Bool {
        return super.requestIsCacheEquivalent(aRequest, toRequest: bRequest)
    }
    
    override func startLoading() {
        let possibleCachedResponse = self.cachedResponseForCurrentRequest()
        if let cachedResponse = possibleCachedResponse {
            print("Serving response from cache")
            let data = cachedResponse.valueForKey("data") as! NSData!
            let mimeType = cachedResponse.valueForKey("mimeType") as! String!
            let encoding = cachedResponse.valueForKey("encoding") as! String!
            let response = NSURLResponse(URL: self.request.URL!, MIMEType: mimeType, expectedContentLength: data.length, textEncodingName: encoding)
            self.client!.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
            self.client!.URLProtocol(self, didLoadData: data)
            self.client!.URLProtocolDidFinishLoading(self)
        } else {
            print("Serving response from NSURLConnection")
            let newRequest = self.request.mutableCopy() as! NSMutableURLRequest
            NSURLProtocol.setProperty(true, forKey: "IlumnoURLProtocolHandleKey", inRequest: newRequest)
            self.connection = NSURLConnection(request: newRequest, delegate: self)
        }
    }
    
    override func stopLoading() {
        if self.connection != nil {
            self.connection.cancel()
        }
        self.connection = nil
    }
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        self.client!.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
        self.response = response
        self.mutableData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        self.client!.URLProtocol(self, didLoadData: data)
        self.mutableData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        self.client!.URLProtocolDidFinishLoading(self)
        self.saveCachedResponse()
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        self.client!.URLProtocol(self, didFailWithError: error)
    }
    
    // MARK: - Cache data with Core Data
    
    func saveCachedResponse() {
        print("Saving cached responde")
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        
        let cachedResponse = NSEntityDescription.insertNewObjectForEntityForName("CachedURLResponse", inManagedObjectContext: context) as NSManagedObject
        cachedResponse.setValue(self.mutableData, forKey: "data")
        cachedResponse.setValue(self.request.URL?.absoluteString, forKey: "url")
        cachedResponse.setValue(NSDate(), forKey: "timestamp")
        cachedResponse.setValue(self.response.MIMEType, forKey: "mimeType")
        cachedResponse.setValue(self.response.textEncodingName, forKey: "encoding")
        
        do {
            try context.save()
        } catch let error {
            print("Could not cache the response \(error)")
        }
    }
    
//    func saveCachedResponse (context: NSManagedObjectContext) {
//        context.performBlockAndWait({ () -> Void in
//            
//            let cachedResponse = NSEntityDescription.insertNewObjectForEntityForName("CachedURLResponse", inManagedObjectContext: context) as NSManagedObject
//            cachedResponse.setValue(self.mutableData, forKey: "data")
//            // etc.
//            
//            do {
//                try context.save()
//            } catch let error {
//                print("Could not cache the response \(error)")
//            }
//        })
//    }
    
    func cachedResponseForCurrentRequest() -> NSManagedObject? {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("CachedURLResponse", inManagedObjectContext: context)
        fetchRequest.entity = entity
        let predicate = NSPredicate(format: "url == %@", (self.request.URL?.absoluteString)!)
        fetchRequest.predicate = predicate
        
        let possibleResult : Array<NSManagedObject>
        do {
            possibleResult = try context.executeFetchRequest(fetchRequest) as! Array<NSManagedObject>
            if !possibleResult.isEmpty {
                return possibleResult[0]
            }
        } catch let error {
            print("Could not load cached response \(error)")
        }
        
        return nil
    }
    
}
