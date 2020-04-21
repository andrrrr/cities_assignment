//
//  DetailView.swift
//  BackbaseAssignment
//
//  Created by Andrei Nevar on 21/04/2020.
//  Copyright © 2020 Andrei Nevar. All rights reserved.
//

import SwiftUI
import MapKit

struct DetailView: View {
    let city: City
    var body: some View {
        NavigationView {
            MapView(city)
            .navigationBarTitle(Text(city.name))
        }
    }
}


struct MapView: UIViewRepresentable {

    let city: City
    init(_ city: City) {
        self.city = city
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {

        let location = CLLocationCoordinate2D(latitude: city.coord.lat,
                                              longitude: city.coord.lat)

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        uiView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = city.name
        annotation.subtitle = city.country
        uiView.addAnnotation(annotation)
    }
}
