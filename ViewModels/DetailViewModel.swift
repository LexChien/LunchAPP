import Foundation

@MainActor
final class DetailViewModel: ObservableObject {
  @Published var restaurant: Restaurant
  @Published var isFavorite: Bool

  init(restaurant: Restaurant) {
    self.restaurant = restaurant
    self.isFavorite = restaurant.isFavorite
  }

  func toggleFavorite() {
    isFavorite.toggle()
    restaurant.isFavorite = isFavorite
  }
}
