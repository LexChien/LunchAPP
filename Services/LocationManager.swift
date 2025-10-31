import CoreLocation

protocol LocationManaging {
  func requestLocation() async throws -> CLLocationCoordinate2D
}

final class LocationManager: NSObject, LocationManaging {
  private let manager: CLLocationManager
  private var continuation: CheckedContinuation<CLLocationCoordinate2D, Error>?

  override init() {
    self.manager = CLLocationManager()
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
  }

  func requestLocation() async throws -> CLLocationCoordinate2D {
    if CLLocationManager.authorizationStatus() == .notDetermined {
      manager.requestWhenInUseAuthorization()
    }

    manager.requestLocation()

    return try await withCheckedThrowingContinuation { continuation in
      self.continuation = continuation
    }
  }
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else { return }
    continuation?.resume(returning: location.coordinate)
    continuation = nil
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    continuation?.resume(throwing: error)
    continuation = nil
  }
}

struct MockLocationManager: LocationManaging {
  var coordinate = CLLocationCoordinate2D(latitude: 25.0330, longitude: 121.5654)

  func requestLocation() async throws -> CLLocationCoordinate2D {
    coordinate
  }
}
