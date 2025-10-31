import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let coordinate = try container.decode([Double].self)
    guard coordinate.count == 2 else {
      throw DecodingError.dataCorruptedError(in: container, debugDescription: "Coordinate requires latitude and longitude")
    }
    self.init(latitude: coordinate[0], longitude: coordinate[1])
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode([latitude, longitude])
  }
}

extension CLLocationCoordinate2D: Equatable {
  public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
  }
}

extension Array where Element == Restaurant {
  func sortedByDistance() -> [Restaurant] {
    sorted { ($0.distance ?? .greatestFiniteMagnitude) < ($1.distance ?? .greatestFiniteMagnitude) }
  }
}
