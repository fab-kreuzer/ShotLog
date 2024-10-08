//
//  LocationManager.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 07.10.24.
//


import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var currentCity: String = ""

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // Request location permissions
        locationManager.startUpdatingLocation() // Start getting location updates
    }

    // Called when location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        reverseGeocode(location: location)
    }

    // Reverse geocode to get city name
    private func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Failed to reverse geocode: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first, let city = placemark.locality {
                DispatchQueue.main.async {
                    self.currentCity = city
                }
            }
        }
    }
}
