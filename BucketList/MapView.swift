//
//  MapView.swift
//  BucketList
//
//  Created by SuShenghung on 2021/2/27.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    // MARK: pass data between MKMapView and SwiftUI's View
    @Binding var centerCoordinate: CLLocationCoordinate2D
    
    // MARK: detail info of annotation
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool
    
    // MARK: annotations being passed in from SwiftUI's locations array
    var annotations: [MKPointAnnotation]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        // 給定annotation，找mapView底下有無recycled view，有的話直接餵給annotation，沒有則新建一個
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // MARK: our uniqueidentifier for view reuse
            let identifier = "Placemark"
            
            // attempt to find a recycled view of mapView, if not found create a new one
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        
        // 當使用者按下annotation的 "i" 按鈕，要做的事
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let placemark = view.annotation as? MKPointAnnotation else { return }
            
            parent.selectedPlace = placemark
            parent.showingPlaceDetails = true
        }
    }
    
    // typealias Context = UIViewRepresentableContext<MKMapView>
}

// MARK: add example annotation for previews
extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "Tainan"
        annotation.subtitle = "Sweet Home"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 22.99, longitude: 120.21)
        return annotation
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(centerCoordinate: .constant(MKPointAnnotation.example.coordinate), selectedPlace: .constant(MKPointAnnotation.example), showingPlaceDetails: .constant(false), annotations: [MKPointAnnotation.example])
    }
}
