//
//  Map3DView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 28/5/25.
//


import SwiftUI
import MapKit

struct Map3DView: UIViewRepresentable {
    @Binding var selectedSpot: Spot?
    @Binding var selectedReward: ChallengeReward?
    @ObservedObject var viewModel: Map3DViewModel

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: Map3DView

        init(_ parent: Map3DView) {
            self.parent = parent
        }

        // Manejamos las anotaciones del mapa 3D
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else {
                return nil
            }

            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "spot")
            annotationView.canShowCallout = true

            if let spotAnnotation = annotation as? UnifiedAnnotation {
                // Configura las vistas de anotación
                if let spot = spotAnnotation.spot {
                    // Visualización de spots completados o no completados
                } else if let reward = spotAnnotation.reward {
                    // Visualización de recompensas
                } else {
                    // Visualización predeterminada
                }
            }

            return annotationView
        }

        // Manejamos la selección de anotaciones en el mapa 3D
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? UnifiedAnnotation {
                if let spot = annotation.spot {
                    parent.selectedSpot = spot
                    parent.viewModel.focusOnAnnotation(annotation: annotation, mapView: mapView)
                } else if let reward = annotation.reward {
                    parent.selectedReward = reward
                    parent.viewModel.focusOnAnnotation(annotation: annotation, mapView: mapView)
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        // Configuración de la cámara 3D
        let camera = MKMapCamera(lookingAtCenter: viewModel.region3D.center, fromDistance: 600, pitch: 75, heading: 0)
        mapView.setCamera(camera, animated: false)

        mapView.showsUserLocation = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true

        if let cameraBoundary = viewModel.cameraBoundary {
            mapView.setCameraBoundary(cameraBoundary, animated: false)
        }
        if let cameraZoomRange = viewModel.cameraZoomRange {
            mapView.setCameraZoomRange(cameraZoomRange, animated: false)
        }

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(viewModel.mapAnnotations)

        // Actualización de la cámara
        let updatedCamera = MKMapCamera(lookingAtCenter: viewModel.region3D.center, fromDistance: 1000, pitch: 60, heading: 0)
        uiView.setCamera(updatedCamera, animated: true)
    }
}
