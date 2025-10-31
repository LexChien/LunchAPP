import Foundation
import CoreLocation

protocol GooglePlacesServicing {
  func fetchRestaurants(
    for coordinate: CLLocationCoordinate2D,
    radius: Double,
    keywords: [String]
  ) async throws -> [Restaurant]
}

struct GooglePlacesService: GooglePlacesServicing {
  private let session: URLSession
  private let apiKeyProvider: () -> String?

  init(
    session: URLSession = .shared,
    apiKeyProvider: @escaping () -> String? = { ProcessInfo.processInfo.environment["PLACES_API_KEY"] }
  ) {
    self.session = session
    self.apiKeyProvider = apiKeyProvider
  }

  func fetchRestaurants(
    for coordinate: CLLocationCoordinate2D,
    radius: Double,
    keywords: [String]
  ) async throws -> [Restaurant] {
    guard let apiKey = apiKeyProvider(), !apiKey.isEmpty else {
      return [Restaurant.placeholder]
    }

    var components = URLComponents(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json")
    components?.queryItems = [
      URLQueryItem(name: "location", value: "\(coordinate.latitude),\(coordinate.longitude)"),
      URLQueryItem(name: "radius", value: String(Int(radius))),
      URLQueryItem(name: "type", value: "restaurant"),
      URLQueryItem(name: "key", value: apiKey)
    ]

    if let keyword = keywords.first {
      components?.queryItems?.append(URLQueryItem(name: "keyword", value: keyword))
    }

    guard let url = components?.url else { return [Restaurant.placeholder] }

    let (data, _) = try await session.data(from: url)
    let response = try? JSONDecoder().decode(PlacesResponse.self, from: data)

    return response?.results.map { result in
      Restaurant(
        id: result.placeID,
        name: result.name,
        rating: result.rating ?? 0,
        priceLevel: result.priceLevel,
        distance: nil,
        address: result.vicinity ?? "",
        latitude: result.geometry.location.lat,
        longitude: result.geometry.location.lng,
        photoReference: result.photos?.first?.photoReference,
        isFavorite: false
      )
    } ?? [Restaurant.placeholder]
  }
}

extension GooglePlacesService {
  static let mock = GooglePlacesService(apiKeyProvider: { "" })
}
