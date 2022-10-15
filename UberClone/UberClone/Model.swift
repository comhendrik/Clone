//
//  Model.swift
//  UberClone
//
//  Created by Hendrik Steen on 15.10.22.
//

import Foundation
import CoreLocation

struct RideRequest {
    var rideType: DrivingMode
    var start: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D
    
    func sendRequest() -> [Drive] {
        //Normal Logic with Server Request to get real data
        
        //Dummy data:
        print(self.destination)
        return [Drive(driver: Driver(firstName: "Max", lastName: "Mustermann", rating: 4.5, coordinate: CLLocationCoordinate2D(latitude: 36.1642836, longitude: -86.7856302), car: Car(name: "Tesla Model 3", type: .standard)), cost: 12.99)]
    }
}

struct Drive: Identifiable {
    var id = UUID().uuidString
    var driver: Driver
    var cost: Double
}

struct Driver {
    var firstName: String
    var lastName: String
    var rating: Double
    var coordinate: CLLocationCoordinate2D
    var car: Car
}

struct Car {
    var name: String
    var type: DrivingMode
}

struct Location: Identifiable {
    let id: UUID
    var name: String
    var description: String
    let location: CLLocation
}

enum DrivingMode: String, CaseIterable {
    
    case standard, medium, luxus
    
    var stringValue: String {
        switch self {
        case .standard:
            return "Standard"
        case .medium:
            return "Medium"
        case .luxus:
            return "Luxus"
        }
    }
    
    var image: String {
        "Car"
    }
    
    var price: Double {
        switch self {
        case .standard:
            return 10.99
        case .medium:
            return 15.99
        case .luxus:
            return 20.99
        }
    }
}
