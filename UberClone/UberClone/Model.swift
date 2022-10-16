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
    var start: CLLocation
    var destination: CLLocation
    
    func sendRequest() -> [Drive] {
        //Normal Logic with Server Request to get real data
        
        //Dummy data:
        print(self.destination)
        return [Drive(driver: Driver(firstName: "Max", lastName: "Mustermann", rating: 4.5, location: CLLocation(latitude: 36.1642836, longitude: -86.7856302), car: Car(name: "Tesla Model 3", type: .standard)), cost: 12.99)]
    }
}

struct Drive: Identifiable {
    var id = UUID().uuidString
    var driver: Driver
    var cost: Double
    
    func bookDrive() -> Bool {
        //Logic for book Drive
        
        //Dummy data:
        return true
    }
}

struct Driver {
    var firstName: String
    var lastName: String
    var rating: Double
    var location: CLLocation
    var car: Car
    
    func getDistanceFromUser(userLocation: CLLocation) -> Double {
        let distanceInMeters = location.distance(from: userLocation)
        return distanceInMeters / 1000
    }
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
