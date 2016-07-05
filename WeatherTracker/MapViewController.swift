//
//  MapViewController.swift
//  WeatherTracker
//
//  Created by Eric Dockery.
//  Copyright © 2016 Eric Dockery. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate{
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    var annotation: MKAnnotation!
    var location: Location! {
        didSet {
            navigationItem.title = location.locationName
        }
    }
    
    
    override func loadView(){
        mapView = MKMapView()
        locationManager = CLLocationManager()
        view = mapView
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), forControlEvents: .ValueChanged)
        let topConstraint = segmentedControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant:8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        topConstraint.active = true
        leadingConstraint.active = true
        trailingConstraint.active = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationCords = CLLocationCoordinate2DMake(location.xCord, location.yCord)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = locationCords
        //print(location.currentTemperature)
        dropPin.title = "\(location.currentTemperature)"
        mapView.addAnnotation(dropPin)
        
    }
    
     func mapTypeChanged(segControl: UISegmentedControl){
        switch segControl.selectedSegmentIndex{
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Hybrid
        case 2:
            mapView.mapType = .Satellite
        default:
            break
        }
    }
    
    private func findLocation(sender: UIButton){
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        mapView.delegate = self
        
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 5, 5)
        mapView.setRegion(zoomedInCurrentLocation, animated: true)
    }
    
}
