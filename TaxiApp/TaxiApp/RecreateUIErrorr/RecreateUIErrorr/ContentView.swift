//
//  ContentView.swift
//  RecreateUIErrorr
//
//  Created by Hendrik Steen on 05.01.23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 54.005, longitude: 8.99736), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.6))
    @State private var mapAnnotations = [Annotation(name: "test", image: "pin", location: CLLocationCoordinate2D(latitude: 54.006, longitude: 8.99888))]
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: mapAnnotations) { anno in
            MapAnnotation(coordinate: anno.location, anchorPoint: CGPoint(x: 0.5, y: 1)) {
                Image(systemName: anno.image)
                Text(anno.name)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Annotation: Identifiable {
    var name: String
    var image: String
    var location: CLLocationCoordinate2D
    var id = UUID()
}
