//
//  MetroRoute.swift
//  Metro
//
//  Created by Theo Phillips on 3/13/16.
//  Copyright © 2016 DurlApps. All rights reserved.
//

import Foundation
import MapKit

class MetroRoute {
    var title:String?
    var id:String?
    
    static func getAllRoutes(completion:(Array<MetroRoute>)->()) {
        let urlString = "http://api.metro.net/agencies/lametro/routes/"
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {
            data, response, error in
            var array = Array<MetroRoute>()
            do {
                if data == nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(array)
                    }
                }
                else {
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                    let jsonArray = jsonData["items"] as! NSArray;
                    for json in jsonArray {
                        let dict = json as! NSDictionary
                        let object = MetroRoute()
                        object.title = dict.objectForKey("display_name") as! String?
                        object.id = dict.objectForKey("id") as! String?
                        array.append(object)
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(array)
                    }
                }
            } catch {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(array)
                }
            }
        })
        task.resume()
    }
    
    static func getVehiclesForRoute(route:MetroRoute, completion:(Array<CLLocationCoordinate2D>,NSError?)->()) {
        let queue = dispatch_queue_create("com.metro.vehicleQueue", nil)
        dispatch_async(queue, {
        let urlString = "http://api.metro.net/agencies/lametro/routes/\(route.id!)/vehicles/"
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {
            data, response, responseError in
            var array = Array<CLLocationCoordinate2D>()
            do {
                if data == nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(array,responseError)
                    }
                }
                else {
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                    let jsonArray = jsonData["items"] as! NSArray;
                    for json in jsonArray {
                        let dict = json as! NSDictionary
                        let lat = dict.objectForKey("latitude") as! Double?
                        let lon = dict.objectForKey("longitude") as! Double?
                        let object = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                        array.append(object)
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(array,responseError)
                    }
                }
            } catch {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(array,responseError)
                }
            }
        })
            task.resume()
            
        })
    }
}