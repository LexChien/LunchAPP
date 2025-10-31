import SwiftUI

@main
struct LunchAppApp: App {
  @StateObject private var viewModel = RestaurantViewModel()

  var body: some Scene {
    WindowGroup {
      NavigationStack {
        RestaurantListView(viewModel: viewModel)
      }
    }
  }
}
