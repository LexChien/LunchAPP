import Foundation

struct UserPreference: Codable, Equatable {
  enum Group: String, CaseIterable, Codable {
    case student
    case office
    case vegetarian
  }

  var group: Group
  var radiusInMeters: Double
  var priceLevelRange: ClosedRange<Int>
  var keywords: [String]

  static let `default` = UserPreference(
    group: .student,
    radiusInMeters: 800,
    priceLevelRange: 1...2,
    keywords: ["quick", "lunch"]
  )
}
