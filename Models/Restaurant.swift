import Foundation
import CoreLocation

struct Restaurant: Identifiable, Codable, Equatable {
  let id: String
  var name: String
  var rating: Double
  var priceLevel: Int?
  var distance: CLLocationDistance?
  var address: String
  var latitude: Double?
  var longitude: Double?
  var photoReference: String?
  var isFavorite: Bool

  var coordinate: CLLocationCoordinate2D? {
    guard let latitude, let longitude else { return nil }
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }

  static let placeholder = Restaurant(
    id: "sample-restaurant",
    name: "Sample Bistro",
    rating: 4.5,
    priceLevel: 2,
    distance: 120,
    address: "123 Main Street",
    latitude: 25.0330,
    longitude: 121.5654,
    photoReference: nil,
    isFavorite: false
  )
}
