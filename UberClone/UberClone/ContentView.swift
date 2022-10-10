//
//  ContentView.swift
//  UberClone
//
//  Created by Hendrik Steen on 30.08.22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var clvm = CoreLocationViewModel()
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    var body: some View {
        ZStack {
            MapView(requestLocation: $clvm.startLocation, destinationLocation: $clvm.endLocation)
            BottomSheet(clvm: clvm)
                .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
