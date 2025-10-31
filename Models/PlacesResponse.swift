import Foundation

struct PlacesResponse: Codable {
  struct Result: Codable {
    struct Geometry: Codable {
      struct Location: Codable {
        let lat: Double
        let lng: Double
      }
      let location: Location
    }

    struct OpeningHours: Codable {
      let openNow: Bool?

      enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
      }
    }

    let placeID: String
    let name: String
    let rating: Double?
    let priceLevel: Int?
    let vicinity: String?
    let geometry: Geometry
    let openingHours: OpeningHours?
    let photos: [Photo]?

    struct Photo: Codable {
      let photoReference: String

      enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
      }
    }

    enum CodingKeys: String, CodingKey {
      case placeID = "place_id"
      case name
      case rating
      case priceLevel = "price_level"
      case vicinity
      case geometry
      case openingHours = "opening_hours"
      case photos
    }
  }

  let results: [Result]
  let nextPageToken: String?

  enum CodingKeys: String, CodingKey {
    case results
    case nextPageToken = "next_page_token"
  }
}
