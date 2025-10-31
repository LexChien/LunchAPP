import Foundation
import SwiftUI
import CoreLocation

@MainActor
final class RestaurantViewModel: ObservableObject {
  @Published var restaurants: [Restaurant] = []
  @Published var isLoading = false
  @Published var alertMessage: String?

  var preference: UserPreference

  private let service: GooglePlacesServicing
  private let locationManager: LocationManaging

  init(
    preference: UserPreference = .default,
    service: GooglePlacesServicing = GooglePlacesService.mock,
    locationManager: LocationManaging = MockLocationManager()
  ) {
    self.preference = preference
    self.service = service
    self.locationManager = locationManager
  }

  func refresh() {
    Task {
      await loadRestaurants()
    }
  }

  private func loadRestaurants() async {
    isLoading = true
    defer { isLoading = false }

    do {
      let coordinate = try await locationManager.requestLocation()
      let items = try await service.fetchRestaurants(
        for: coordinate,
        radius: preference.radiusInMeters,
        keywords: preference.keywords
      )
      restaurants = items
    } catch {
      alertMessage = error.localizedDescription
      restaurants = [Restaurant.placeholder]
    }
  }
}
