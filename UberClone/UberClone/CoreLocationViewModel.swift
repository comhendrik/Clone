//
//  CoreLocationViewModel.swift
//  UberClone
//
//  Created by Hendrik Steen on 10.10.22.
//

import Foundation
import Combine
import CoreLocation


@MainActor
class CoreLocationViewModel: ObservableObject {
    
    @Published var startLocation : CLLocationCoordinate2D? = nil
    
    @Published  var endLocation : CLLocationCoordinate2D? = nil
    
    @Published var alertMsg: String = ""
    
    @Published var showAlert: Bool = false
    
    func setRouteLocations(start: String, end: String, ride: DrivingMode) async {
        
        
        
        startLocation = nil
        
        endLocation = nil
        
        self.startLocation = await getLocation(forPlaceCalled: start)
        
        self.endLocation = await getLocation(forPlaceCalled: end)
        
        if startLocation == nil {
            print("yea")
            alertMsg = "Be more precisely when describing your start location."
            showAlert.toggle()
        } else if endLocation == nil {
            print("No")
            alertMsg = "Be more precisely when describing your end location."
            showAlert.toggle()
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
    
    let geocoder = CLGeocoder()
    do {
        let placemark = try await geocoder.geocodeAddressString(name)
        return placemark[0].location?.coordinate
    } catch {
        return nil
    }
}
    
    
    
    
    
    
    
    
