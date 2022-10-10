//
//  CoreLocationViewModel.swift
//  UberClone
//
//  Created by Hendrik Steen on 10.10.22.
//

import Foundation
import Combine
import CoreLocation

class CoreLocationViewModel: ObservableObject {
    
    @Published var startLocation : CLLocationCoordinate2D? = nil
    
    @Published  var endLocation : CLLocationCoordinate2D? = nil
    
    @Published var alertMsg: String = ""
    
    @Published var showAlert: Bool = false
    
    func setRouteLocations(start: String, end: String) {
        
        getLocation(forPlaceCalled: start) { location in
            self.startLocation = location?.coordinate
        }
        
        getLocation(forPlaceCalled: end) { location in
            self.endLocation = location?.coordinate
        }
        
        if startLocation == nil {
            alertMsg = "Be more precisely when describing your start location."
            showAlert.toggle()
        } else if endLocation == nil {
            alertMsg = "Be more precisely when describing your end location."
            showAlert.toggle()
        } else {
            alertMsg = "Your Route is shown on the map"
            showAlert.toggle()
        }
    }
    
}

struct Location: Identifiable {
    let id: UUID
    var name: String
    var description: String
    let location: CLLocation
}

//TODO: Find fitting place for function
func getLocation(forPlaceCalled name: String,
                 completion: @escaping(CLLocation?) -> Void) {
    
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(name) { placemarks, error in
        
        guard error == nil else {
            print("*** Error in \(#function): \(error!.localizedDescription)")
            completion(nil)
            return
        }
        
        guard let placemark = placemarks?[0] else {
            print("*** Error in \(#function): placemark is nil")
            completion(nil)
            return
        }
        
        guard let location = placemark.location else {
            print("*** Error in \(#function): placemark is nil")
            completion(nil)
            return
        }

        completion(location)
    }
}
    
    
    
    
    
    
    
    
