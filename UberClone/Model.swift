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
        print(drivingMode.intValue)
        let queries = queryBounds.map { bound -> Query in
            return db.collection("Driver")
                .whereField("carType", isEqualTo: drivingMode.intValue)
                .whereField("isWorking", isEqualTo: true)
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
                    
                    let id = document.documentID
                    
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
                                                               pricePerArrivingKM: pricePerArrivingKM,
                                                               id: id,
                                                               isWorking: true
                                                              ),
                                                start: start,
                                                destination: destination))
                    
                }
                
            }
            return drivingOptions
        } catch {
            print(error.localizedDescription)
            return []
        }
        
        
    }
}

struct PossibleDrive: Identifiable, Equatable {
    var id: String
    var userLocation: CLLocation
    var userDestination: CLLocation
    var price: Double
    var isDestinationAnnotation: Bool
}



struct Drive: Identifiable, Equatable {
    static func == (lhs: Drive, rhs: Drive) -> Bool {
        lhs.id == rhs.id && lhs.driver == rhs.driver && lhs.start == rhs.destination
    }
    
    var id = UUID().uuidString
    var driver: Driver
    var start: CLLocation
    var destination: CLLocation
    //TODO: Get the logic from avm here
    
    func bookDrive() -> DriveStatus {
        //Logic for book Drive
        db.collection("Driver").document(driver.id).collection("PossibleDrives").addDocument(data:
                                                                                                ["userLatitude" : start.coordinate.latitude,
                                                                                                 "userLongitude": start.coordinate.longitude,
                                                                                                 "destinationLatitude": destination.coordinate.latitude,
                                                                                                 "destinationLongitude" : destination.coordinate.longitude,
                                                                                                 "price": calculateDriveCost()
                                                                                                ]
        )
        
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

//TODO: Put Driver and DriverAccount together
struct Driver: Equatable {
    static func == (lhs: Driver, rhs: Driver) -> Bool {
        lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.rating == rhs.rating && lhs.location == rhs.location && lhs.car == rhs.car && lhs.pricePerKM == rhs.pricePerKM && lhs.pricePerArrivingKM == rhs.pricePerArrivingKM && lhs.id == rhs.id && lhs.isWorking == rhs.isWorking
    }
    
    var firstName: String
    var lastName: String
    var rating: Double
    var location: CLLocation
    var car: Car
    var pricePerKM: Double
    var pricePerArrivingKM: Double
    var id: String
    var isWorking: Bool
    
    func getDistanceFromUser(userLocation: CLLocation) -> Double {
        let distanceInMeters = location.distance(from: userLocation)
        return distanceInMeters / 1000
    }
}

struct Car: Equatable {
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
            return 0
        case .medium:
            return 1
        case .luxus:
            return 2
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


struct CustomMapAnnotation: Identifiable, Equatable {
    static func == (lhs: CustomMapAnnotation, rhs: CustomMapAnnotation) -> Bool {
        lhs.id == rhs.id && lhs.location == rhs.location && lhs.type == lhs.type && lhs.drive == rhs.drive
    }
    
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

struct DriverAccount {
    var firstName: String
    var lastName: String
    var rating: Double
    var location: CLLocation
    var car: Car
    var pricePerKM: Double
    var pricePerArrivingKM: Double
    var id: String
    var isWorking: Bool
    
    init(id: String) async {
        do {
            //TODO: adding dynamic fetching
            let document = try await db.collection("Driver").document(id).getDocument()
            self.firstName = document.data()?["firstName"] as? String ?? "no firstName"
            self.lastName = document.data()?["lastName"] as? String ?? "no lastName"
            self.rating = document.data()?["rating"] as? Double ?? 0
            self.isWorking = document.data()?["isWorking"] as? Bool ?? false
            self.id = document.documentID
            
            self.pricePerKM = document.data()?["pricePerKM"] as? Double ?? 0
            self.pricePerArrivingKM = document.data()?["pricePerArrivingKM"] as? Double ?? 0
            
            let lat = document.data()?["latitude"] as? Double ?? 0
            let lng = document.data()?["longitude"] as? Double ?? 0
            self.location = CLLocation(latitude: lat, longitude: lng)
            
            let carName = document.data()?["carName"] as? String ?? "no carName"
            let carType = document.data()?["carType"] as? Int ?? 1
            
            if carType == 1 {
                self.car = Car(name: carName, type: .standard)
            } else if carType == 2 {
                self.car = Car(name: carName, type: .medium)
            } else {
                self.car = Car(name: carName, type: .luxus)
            }
        } catch {
            print(error.localizedDescription)
            self.firstName = "err"
            self.lastName = "err"
            self.rating = 0.0
            self.location = CLLocation(latitude: 0, longitude: 0)
            self.car = Car(name: "err", type: .medium)
            self.pricePerKM = 0.0
            self.pricePerArrivingKM = 0.0
            self.id = "err"
            self.isWorking = false
        }
    }
    
    func updateDrivingData(id: String, isWorking: Bool, pricePerArrivingKM: String, pricePerKM: String) async -> String {
        
        
        if let pricePerArrivingKM = pricePerArrivingKM.doubleValue, let pricePerKM = pricePerKM.doubleValue {
            do {
                try await db.collection("Driver").document(id).updateData([
                    "isWorking": isWorking,
                    "pricePerArrivingKM" : pricePerArrivingKM,
                    "pricePerKM" : pricePerKM
                ])
                return "Succesfully changed Driver Status"
            } catch {
                return error.localizedDescription
            }
            
        }
        return "Please check your input for your price changes. Those have to be numbers."
    }
    
    func fetchPossibleDrives(id: String) async -> [PossibleDrive] {
        do {
            var possibleDrives: [PossibleDrive] = []
            let docs = try await db.collection("Driver").document(id).collection("PossibleDrives").getDocuments()
            for doc in docs.documents {
                let docID = doc.documentID
                let userLatitude = doc.data()["userLatitude"] as? Double ?? 0.0
                let userLongitude = doc.data()["userLongitude"] as? Double ?? 0.0
                let destinationLatitude = doc.data()["destinationLatitude"] as? Double ?? 0.0
                let destinationLongitude = doc.data()["destinationLongitude"] as? Double ?? 0.0
                let price = doc.data()["price"] as? Double ?? 0.0
                
                possibleDrives.append(PossibleDrive(id: docID, userLocation: CLLocation(latitude: userLatitude, longitude: userLongitude), userDestination: CLLocation(latitude: destinationLatitude, longitude: destinationLongitude), price: price, isDestinationAnnotation: false))
            }
            return possibleDrives
        } catch {
            print(error.localizedDescription)
            return []
        }
        
    }
}


extension String {
    
    // get double value from String or nil
    var doubleValue: Double? { return Double(self) }
}


//Needed to make .onChange possible 

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.center == rhs.center && lhs.span == rhs.span
    }
    
    
}

extension MKCoordinateSpan: Equatable {
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        return lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
    }
    
    
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    
}

