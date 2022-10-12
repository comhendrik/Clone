//
//  CoreLocationViewModel.swift
//  UberClone
//
//  Created by Hendrik Steen on 10.10.22.
//

import Foundation
import Combine
import CoreLocation


//TODO: Bring them in one class together

@MainActor
class CoreLocationViewModel: ObservableObject {
    
    
    
    @Published var startLocation : CLLocationCoordinate2D? = nil
    
    @Published  var endLocation : CLLocationCoordinate2D? = nil
    
    @Published var alertMsg: String = ""
    
    @Published var showAlert: Bool = false
    
    func setRouteLocations(end: String, ride: DrivingMode) async {
        
        self.endLocation = await getLocation(forPlaceCalled: end)
        
        if startLocation == nil {
            print(1)
            alertMsg = "Be more precisely when describing your start location."
            showAlert = true
        } else if endLocation == nil {
            print(2)
            alertMsg = "Be more precisely when describing your end location."
            showAlert = true
        } else {
            let rideRequest = RideRequest(rideType: ride, start: startLocation!, destination: endLocation!)
            print(rideRequest)
            alertMsg = "Your Route is shown on the map"
            showAlert.toggle()
        }
    }
    
}

struct RideRequest {
    var rideType: DrivingMode
    var start: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D
}

struct Location: Identifiable {
    let id: UUID
    var name: String
    var description: String
    let location: CLLocation
}

//TODO: Find fitting place for function
func getLocation(forPlaceCalled name: String) async -> CLLocationCoordinate2D? {
    
    
    do {
        let geocoder = CLGeocoder()
        let placemark = try await geocoder.geocodeAddressString(name)
        return placemark[0].location?.coordinate
    } catch {
        return nil
    }
}


class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    
    @Published var userLocation: CLLocation?
    
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
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
