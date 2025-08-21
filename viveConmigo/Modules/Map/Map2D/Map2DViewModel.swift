//
//  Map2DViewModel.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import Foundation
import MapKit

class Map2DViewModel: BaseMapViewModel {
    @Published var region2D: MKCoordinateRegion

    override init(appState: AppState) {
        // Usa las propiedades del BaseMapViewModel para inicializar la región 2D
        self.region2D = MKCoordinateRegion()  // Inicializa con un valor temporal
        super.init(appState: appState)
        
        // Luego de la inicialización de la superclase, usa `self.centerCoordinate` y `self.zoomLevel`
        self.region2D = MKCoordinateRegion(
            center: self.centerCoordinate,
            span: MKCoordinateSpan(latitudeDelta: self.zoomLevel, longitudeDelta: self.zoomLevel)
        )

        // Print para depuración
        print("2D Map initialized with center: \(self.centerCoordinate.latitude), \(self.centerCoordinate.longitude) and zoom level: \(self.zoomLevel)")
    }

    // Actualiza la región del mapa cuando se obtiene la ubicación del usuario
    override func updateRegionWithUserLocation(_ coordinate: CLLocationCoordinate2D) {
        self.region2D.center = coordinate
        self.centerCoordinate = coordinate  // Sincroniza el centro en BaseMapViewModel
        //print("2D Map region updated with user location: \(coordinate.latitude), \(coordinate.longitude)")
    }

    // Actualiza el nivel de zoom del mapa 2D
    func updateZoomLevel(_ zoom: Double) {
        self.region2D.span = MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
        self.zoomLevel = zoom  // Actualiza el zoom en BaseMapViewModel para sincronizarlo con 3D

        // Print para verificar el zoom
        print("Zoom level updated to: \(zoom) for 2D map")
    }
}
