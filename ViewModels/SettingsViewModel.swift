import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
  @Published var preference: UserPreference

  init(preference: UserPreference = .default) {
    self.preference = preference
  }

  func updateGroup(_ group: UserPreference.Group) {
    preference.group = group
  }

  func updateRadius(_ radius: Double) {
    preference.radiusInMeters = radius
  }

  func updatePriceLevel(range: ClosedRange<Int>) {
    preference.priceLevelRange = range
  }

  func updateKeywords(_ keywords: [String]) {
    preference.keywords = keywords
  }
}
