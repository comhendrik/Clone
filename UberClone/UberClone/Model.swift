//
//  Model.swift
//  UberClone
//
//  Created by Hendrik Steen on 15.10.22.
//

import Foundation
import CoreLocation
import SwiftUI
import GeoFire
import FirebaseFirestore

let db = Firestore.firestore()

struct RideRequest {
    var drivingMode: DrivingMode
    var start: CLLocation
    var destination: CLLocation
    
    func sendRequest(radius: Int) async -> [Drive] {
        let center = CLLocationCoordinate2D(latitude: start.coordinate.latitude, longitude: start.coordinate.longitude)
        let radiusInM = Double(radius) * 1000
        
        
        let queryBounds = GFUtils.queryBounds(forLocation: center,
                                              withRadius: radiusInM)
        
    
        let queries = queryBounds.map { bound -> Query in
            return db.collection("Driver")
                .order(by: "geohash")
                .start(at: [bound.startValue])
                .end(at: [bound.endValue])
                
        }
        
        do {
            var drivingOptions: [Drive] = []
            for query in queries {
                let documents = try await query.getDocuments()
                
                
                let allDocs = documents.documents

                for document in allDocs {
                    let firstName = document.data()["firstName"] as? String ?? "no firstName"
                    let lastName = document.data()["lastName"] as? String ?? "no lastName"
                    let rating = document.data()["rating"] as? Double ?? 0
                    
                    let pricePerKM = document.data()["pricePerKM"] as? Double ?? 0
                    let pricePerArrivingKM = document.data()["pricePerArrivingKM"] as? Double ?? 0
                    
                    let lat = document.data()["latitude"] as? Double ?? 0
                    let lng = document.data()["longitude"] as? Double ?? 0
                    let coordinates = CLLocation(latitude: lat, longitude: lng)
                    
                    let carName = document.data()["carName"] as? String ?? "no carName"
                    
                    drivingOptions.append(Drive(driver: Driver(firstName: firstName,
                                                               lastName: lastName,
                                                               rating: rating,
                                                               location: coordinates,
                                                               car: Car(name: carName,
                                                                        //TODO: Real fetching with driving Mode
                                                                        type: drivingMode),
                                                               pricePerKM: pricePerKM,
                                                               pricePerArrivingKM: pricePerArrivingKM),
                                                start: start,
                                                destination: destination))
                }
                
            }
            return drivingOptions
        } catch {
            print("error")
            return []
        }
        
        
    }
}



struct Drive: Identifiable {
    var id = UUID().uuidString
    var driver: Driver
    var start: CLLocation
    var destination: CLLocation
    //TODO: Get the logic from avm here
    
    func bookDrive() -> DriveStatus {
        //Logic for book Drive
        
        //Send Notification to driver and add it to user
        //Dummy data:
        return .pending
    }
    
    func getNewestInformation(with status: DriveStatus) -> DriveStatus {
        //with status is dummy data
        return status
    }
    
    //TODO: Calculate cost with real street km data and not just a straight line over the map
    
    func calculateDrivingDistance() -> Double {
         return destination.distance(from: start) / 1000
    }
    
    func calculateCostForRide() -> Double {
        
        return calculateDrivingDistance() * driver.pricePerKM
    }
    
    func calculateCostForArriving() -> Double {
        let distanceInKM = driver.getDistanceFromUser(userLocation: start)
        return distanceInKM * driver.pricePerArrivingKM
    }
    
    func calculateDriveCost() -> Double {
        return  driver.car.type.price + calculateCostForArriving() + calculateCostForRide()
    }
    
}

struct Driver {
    var firstName: String
    var lastName: String
    var rating: Double
    var location: CLLocation
    var car: Car
    var pricePerKM: Double
    var pricePerArrivingKM: Double
    
    func getDistanceFromUser(userLocation: CLLocation) -> Double {
        let distanceInMeters = location.distance(from: userLocation)
        return distanceInMeters / 1000
    }
}

struct Car {
    var name: String
    var type: DrivingMode
}

enum DriveStatus {
    case cancelled, success, pending, arriving, notBooked, driving
    
    var responseValue: String {
        switch self {
        case .cancelled:
            return "Drive was cancelled."
        case .success:
            return "Drive finished"
        case .pending:
            return "pending..."
        case .arriving:
            return "Drive is arriving"
        case .notBooked:
            return "No booked Drive"
        case .driving:
            return "You are on the way"
        }
    }
    
    var systemImage: String {
        switch self {
        case .cancelled:
            return "xmark.seal"
        case .success:
            return "checkmark.seal"
        case .pending:
            return "car.fill"
        case .arriving:
            return "car"
        case .notBooked:
            return "car"
        case .driving:
            return "car"
        }
    }
        
    var systemImageColor: Color {
        switch self {
        case .cancelled:
            return .red
        case .success:
            return .green
        case .pending:
            return .gray
        case .arriving:
            return .green
        case .notBooked:
            return .red
        case .driving:
            return .blue
        }
    }
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
    
    var intValue: Int {
        switch self {
        case .standard:
            return 1
        case .medium:
            return 2
        case .luxus:
            return 3
        }
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


struct CustomMapAnnotation: Identifiable {
    var id = UUID().uuidString
    var location: CLLocation
    var type: AnnotationType
    var drive: Drive?
}

enum AnnotationType {
    case drive, destination
    
    var systemImage: String {
        switch self {
        case .drive:
            return "car.circle"
        case .destination:
            return "mappin.circle.fill"
        }
    }
    
    var imageColor: Color {
        switch self {
        case .drive:
            return .blue
        case .destination:
            return .green
        }
    }
}
