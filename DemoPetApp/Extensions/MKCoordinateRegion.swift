//
//  MKCoordinateRegion.swift
//  DemoPetApp
//
//  Created by Fabian on 31.10.2023.
//

import MapKit

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.span.latitudeDelta == rhs.span.latitudeDelta &&
            lhs.span.longitudeDelta == rhs.span.longitudeDelta &&
            lhs.center.latitude == rhs.center.latitude &&
            lhs.center.longitude == rhs.center.longitude
    }
}

extension MKCoordinateRegion {
    public var metersInLongitude: CLLocationDistance {
        let loc1 = CLLocation(latitude: center.latitude, longitude: center.longitude - span.longitudeDelta * 0.5)
        let loc2 = CLLocation(latitude: center.latitude, longitude: center.longitude + span.longitudeDelta * 0.5)
    
        return loc1.distance(from: loc2)
    }
    
    public var milesInLongitude: CLLocationDistance {
        Measurement(value: metersInLongitude, unit: UnitLength.meters).converted(to: .miles).value
    }
}
