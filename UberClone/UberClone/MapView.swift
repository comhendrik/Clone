//
//  MapView.swift
//  UberClone
//
//  Created by Hendrik Steen on 30.08.22.
//

import SwiftUI
import MapKit

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

    @Binding var requestLocation: CLLocationCoordinate2D?
    @Binding var destinationLocation: CLLocationCoordinate2D?

    private let mapView = WrappableMapView()
    
    

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> WrappableMapView {
        mapView.delegate = mapView
        return mapView
    }

    func updateUIView(_ uiView: WrappableMapView, context: UIViewRepresentableContext<MapView>) {
        
        print("update")
        
        let _annotations = mapView.annotations
        print(_annotations)
        
        if requestLocation != nil && destinationLocation != nil {
            let requestAnnotation = MKPointAnnotation()
            requestAnnotation.coordinate = requestLocation!
            requestAnnotation.title = "Start"
            uiView.addAnnotation(requestAnnotation)
            
            let destinationAnnotation = MKPointAnnotation()
            destinationAnnotation.coordinate = destinationLocation!
            destinationAnnotation.title = "Destination"
            uiView.addAnnotation(destinationAnnotation)

            let requestPlacemark = MKPlacemark(coordinate: requestLocation!)
            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation!)

            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: requestPlacemark)
            
            directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
            
            
            
            
            
         
            let directions = MKDirections(request: directionRequest)
                  directions.calculate { response, error in
                      guard let response = response else { return }

                      let route = response.routes[0]
                      uiView.addOverlay(route.polyline, level: .aboveRoads)
                      let rect = route.polyline.boundingMapRect
                      uiView.setRegion(MKCoordinateRegion(rect), animated: true)
                      uiView.setRegion(MKCoordinateRegion(rect), animated: true)
                      
                       uiView.setVisibleMapRect(rect, edgePadding: .init(top: 10.0, left: 50.0, bottom: 50.0, right: 50.0), animated: true)
                      
                  }
        }

    }
    func setMapRegion(_ region: CLLocationCoordinate2D){
        mapView.region = MKCoordinateRegion(center: region, latitudinalMeters: 60000, longitudinalMeters: 60000)
    }
    
    
}

class WrappableMapView: MKMapView, MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        renderer.lineWidth = 4.0
        return renderer
    }
  
}


