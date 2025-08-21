//
//  WalkingTaskView.swift
//  viveConmigo
//
//  Created by Markel Juaristi on 11/6/25.
//

import SwiftUI
import CoreLocation

struct WalkingTaskView: View {
    @State private var message: String = "Camina 500 metros en línea recta"
    @State private var locationManager = CLLocationManager()
    @State private var currentLocation: CLLocation?
    @State private var distance: Double = 0

    let distanceThreshold: Double = 500.0

    var body: some View {
        ZStack {
            Fondo()

            VStack(spacing: 30) {
                Text(message)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.mateGold)
                    .padding()

                Button(action: {
                    checkWalkingProgress()
                }) {
                    Text("Comprobar movimiento")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.mateBlueMedium)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .padding()
        }
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    func checkWalkingProgress() {
        guard let location = locationManager.location else {
            message = "No se pudo obtener tu ubicación."
            return
        }

        currentLocation = location
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        let defaults = UserDefaults.standard

        let savedDate = defaults.string(forKey: "lastWalkingDate")
        let savedLat = defaults.double(forKey: "lastWalkingLat")
        let savedLon = defaults.double(forKey: "lastWalkingLon")

        if savedDate != today || savedLat == 0.0 || savedLon == 0.0 {
            // Nuevo día o sin datos previos → guardar nueva ubicación base
            defaults.set(today, forKey: "lastWalkingDate")
            defaults.set(location.coordinate.latitude, forKey: "lastWalkingLat")
            defaults.set(location.coordinate.longitude, forKey: "lastWalkingLon")

            message = "Inicio registrado. Ahora camina 500 metros."
            return
        }

        // Calcular distancia
        let startLocation = CLLocation(latitude: savedLat, longitude: savedLon)
        let meters = location.distance(from: startLocation)

        distance = meters

        if meters >= distanceThreshold {
            message = "🎉 ¡Felicidades, has caminado 500 metros!"
        } else {
            let remaining = Int(distanceThreshold - meters)
            message = "Aléjate más en línea recta (\(remaining)m restantes)"
        }
    }
}
