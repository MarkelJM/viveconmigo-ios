//
//  Mao3DViewModel.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import Foundation
import MapKit

class Map3DViewModel: BaseMapViewModel {
    @Published var selectedSpot: Spot?
    @Published var selectedReward: ChallengeReward?
    @Published var region3D: MKCoordinateRegion
    @Published var cameraBoundary: MKMapView.CameraBoundary?
    @Published var cameraZoomRange: MKMapView.CameraZoomRange?
    
    // Mantenemos la referencia al MKMapView para poder actualizar la cámara directamente
    weak var mapView: MKMapView?

    override init(appState: AppState) {
        // Inicializa la región 3D con un valor temporal
        self.region3D = MKCoordinateRegion()  // Inicializa con un valor temporal
        super.init(appState: appState)
        
        // Luego de la inicialización de la superclase, usa `self.centerCoordinate` y `self.zoomLevel`
        self.region3D = MKCoordinateRegion(
            center: self.centerCoordinate,
            span: MKCoordinateSpan(latitudeDelta: self.zoomLevel, longitudeDelta: self.zoomLevel)
        )
        setup3DCamera()

        // Print para depuración
        print("3D Map initialized with center: \(self.centerCoordinate.latitude), \(self.centerCoordinate.longitude) and zoom level: \(self.zoomLevel)")
    }

    // Configuración de la cámara en el mapa 3D
    func setup3DCamera() {
        guard let mapView = mapView else { return }

        // Ajustar los límites y el rango de zoom de la cámara
        self.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: region3D)
        self.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 500, maxCenterCoordinateDistance: 50000)

        // Establecer la cámara inicial en la ubicación de la región
        let camera = MKMapCamera(lookingAtCenter: region3D.center, fromDistance: 1000, pitch: 60, heading: 0)
        mapView.setCamera(camera, animated: false)

        print("3D Camera setup completed at region center: \(region3D.center.latitude), \(region3D.center.longitude)")
    }

    // Actualiza la región del mapa cuando se obtiene la ubicación del usuario
    override func updateRegionWithUserLocation(_ coordinate: CLLocationCoordinate2D) {
        self.region3D.center = coordinate
        self.centerCoordinate = coordinate  // Sincroniza el centro en BaseMapViewModel
        
        update3DCameraWithUserLocation(coordinate)

        print("3D Map region updated with user location: \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    // Actualiza la cámara del mapa 3D con la ubicación del usuario
    private func update3DCameraWithUserLocation(_ coordinate: CLLocationCoordinate2D) {
        guard let mapView = mapView else { return }

        // Crear y configurar una nueva cámara con la ubicación del usuario
        let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 1000, pitch: 60, heading: 0)
        mapView.setCamera(camera, animated: true)

        print("3D Camera updated with user location: \(coordinate.latitude), \(coordinate.longitude)")
    }

    // Actualiza el nivel de zoom en el mapa 3D
    func updateZoomLevel(_ zoom: Double) {
        self.region3D.span = MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
        self.zoomLevel = zoom  // Sincroniza el nivel de zoom en BaseMapViewModel

        // Print para verificar el zoom
        print("Zoom level updated to: \(zoom) for 3D map")
    }

    // Método para centrar la cámara en una anotación seleccionada en el mapa 3D
    func focusOnAnnotation(annotation: UnifiedAnnotation, mapView: MKMapView) {
        let camera = MKMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 1000, pitch: 60, heading: 0)
        mapView.setCamera(camera, animated: true)

        // Print para verificar la coordenada de la anotación
        print("Focusing on annotation at: \(annotation.coordinate.latitude), \(annotation.coordinate.longitude) in 3D map")
    }

    // Método para manejar la selección de anotaciones en el mapa 3D
    func handleAnnotationSelection(annotation: UnifiedAnnotation, mapView: MKMapView) {
        if let spot = annotation.spot {
            self.selectedSpot = spot
            focusOnAnnotation(annotation: annotation, mapView: mapView)
        } else if let reward = annotation.reward {
            self.selectedReward = reward
            focusOnAnnotation(annotation: annotation, mapView: mapView)
        }

        // Print para verificar qué anotación se ha seleccionado
        if let spot = annotation.spot {
            // Usamos spot.coordinates.latitude y spot.coordinates.longitude
            print("Selected spot annotation at: \(spot.name) - Coordinate: \(spot.coordinates.latitude), \(spot.coordinates.longitude)")
        } else if let reward = annotation.reward {
            print("Selected reward annotation for: \(reward.challengeTitle)")
        }
    }
}
