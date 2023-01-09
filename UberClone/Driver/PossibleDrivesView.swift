//
//  PossibleDrivesView.swift
//  Driver
//
//  Created by Hendrik Steen on 09.01.23.
//

import SwiftUI
import CoreLocation
import MapKit

struct PossibleDrivesView: View {
    let possiblesDrives = [PossibleDrive(id: "1", destination: CLLocation(latitude: 54.7709, longitude: 8.77388), price: 29.99),PossibleDrive(id: "2", destination: CLLocation(latitude: 54.6709, longitude: 8.77388), price: 15.99),PossibleDrive(id: "3", destination: CLLocation(latitude: 54.7909, longitude: 8.77388), price: 29.99)]
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: possiblesDrives) { drive in
            MapAnnotation(coordinate: drive.destination.coordinate) {
                Text("\(drive.price, specifier: "%.2f")")
            }
        }
    }
}

struct PossibleDrivesView_Previews: PreviewProvider {
    static var previews: some View {
        PossibleDrivesView()
    }
}
