//
//  UserAnnotation.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import Foundation
import CoreLocation

struct UserAnnotation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D?
}
