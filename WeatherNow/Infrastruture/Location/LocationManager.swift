//  LocationManager.swift
//  Created by Vino_Swify on 25/08/25.

import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var coord: CLLocationCoordinate2D?
    @Published var status: CLAuthorizationStatus = .notDetermined

    // retry state (for kCLErrorLocationUnknown)
    private var retryCount = 0
    private let maxRetries = 5

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        status = manager.authorizationStatus
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            start()
        }
    }

    /// Start continuous updates and ask for an immediate fix.
    func start() {
        retryCount = 0
        manager.startUpdatingLocation()
        manager.requestLocation()
    }

    /// Nudge Core Location once (use on appear / foreground)
    func requestOneShot() {
        manager.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async { self.status = status }
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            start()
        case .denied, .restricted:
            manager.stopUpdatingLocation()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let c = locations.last?.coordinate else { return }
        retryCount = 0                        // got a fix → reset retries
        DispatchQueue.main.async { self.coord = c }

        #if !targetEnvironment(simulator)
        // On real devices we can stop after a good fix
        manager.stopUpdatingLocation()
        #endif
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let nsErr = error as NSError
        #if DEBUG
        print("Location error:", nsErr.domain, nsErr.code)
        #endif

        // kCLErrorLocationUnknown (code 0): try again shortly
        if nsErr.domain == kCLErrorDomain as String && nsErr.code == CLError.locationUnknown.rawValue {
            guard retryCount < maxRetries else { return }
            retryCount += 1
            let delay = Double(retryCount) * 0.6      // backoff: 0.6s, 1.2s, 1.8s, ...
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.manager.requestLocation()
            }
            return
        }
    }
}
