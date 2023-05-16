//
//  CoreLocationViewModel.swift
//  UberClone
//
//  Created by Hendrik Steen on 10.10.22.
//

import Foundation
import Combine
import CoreLocation
import MapKit



class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var authorizationStatus: CLAuthorizationStatus
    
    @Published var userLocation: CLLocation?
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        region.center = getUserLocation()?.coordinate ?? CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func getUserLocation() -> CLLocation? {
        userLocation = locationManager.location
        return userLocation
    }
}



//TODO: Find fitting place for function
func getLocation(forPlaceCalled name: String) async -> CLLocation? {
    do {
        let geocoder = CLGeocoder()
        let placemark = try await geocoder.geocodeAddressString(name)
        return placemark[0].location
    } catch {
        return nil
    }
}



