//
//  DetailViewController.swift
//  Metro
//
//  Created by Theo Phillips on 3/13/16.
//  Copyright © 2016 DurlApps. All rights reserved.
//

import UIKit
import MapKit


class Vehicle: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}

class DetailViewController: UIViewController, MKMapViewDelegate {
    
    var mapView = MKMapView()
    var refreshButton:UIBarButtonItem?
    var route:MetroRoute
    var vehicleLocations = Array<CLLocationCoordinate2D>()
    
    init(route:MetroRoute) {
        self.route = route
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.route.title
        
        refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshData")
        self.navigationItem.rightBarButtonItem = refreshButton!
        
        self.view.addSubview(mapView)
        let losAngeles = CLLocation(latitude: 33.959, longitude: -118.245)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(losAngeles.coordinate,100000, 100000), animated: true)
        
        self.refreshData()
    }
    
    override func viewDidLayoutSubviews() {
        mapView.frame = self.view.frame
    }
    
    func refreshData() {
        print("requesting vehicles")
        refreshButton?.enabled = false
        refreshButton?.tintColor = UIColor.lightGrayColor()
        MetroRoute.getVehiclesForRoute(self.route, completion: {
            response,error in
            if(error != nil) {
                let alert = UIAlertController(title: nil, message: error?.localizedDescription, preferredStyle: .Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                let cancelAction = UIAlertAction(title: "Close", style: .Cancel, handler: nil)
                alert.addAction(cancelAction)
            }
            print("received \(response.count) vehicles")
            self.refreshButton?.enabled = true
            self.refreshButton?.tintColor = UIColor.blackColor()
            self.vehicleLocations = response
            self.refreshMap()
        })
    }
    
    func refreshMap() {
        mapView.removeAnnotations(mapView.annotations)
        for location in vehicleLocations  {
            let vehicle = Vehicle(coordinate: location)
            mapView.addAnnotation(vehicle)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}