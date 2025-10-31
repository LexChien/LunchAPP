import SwiftUI

struct RestaurantListView: View {
  @ObservedObject var viewModel: RestaurantViewModel

  var body: some View {
    List(viewModel.restaurants) { restaurant in
      NavigationLink(value: restaurant.id) {
        RestaurantRow(restaurant: restaurant)
      }
    }
    .overlay(alignment: .center) { loadingOverlay }
    .navigationTitle("午餐要吃什麼")
    .task { viewModel.refresh() }
    .alert("Oops", isPresented: alertBinding) {
      Button("OK", role: .cancel) { viewModel.alertMessage = nil }
    } message: {
      Text(viewModel.alertMessage ?? "Unknown error")
    }
    .navigationDestination(for: String.self) { id in
      if let restaurant = viewModel.restaurants.first(where: { $0.id == id }) {
        RestaurantDetailView(viewModel: DetailViewModel(restaurant: restaurant))
      } else {
        Text("Restaurant not found")
      }
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        NavigationLink("Settings") {
          SettingsView(viewModel: SettingsViewModel(preference: viewModel.preference))
        }
      }
    }
  }

  private var alertBinding: Binding<Bool> {
    Binding(
      get: { viewModel.alertMessage != nil },
      set: { newValue in
        if !newValue {
          viewModel.alertMessage = nil
        }
      }
    )
  }

  @ViewBuilder
  private var loadingOverlay: some View {
    if viewModel.isLoading {
      ProgressView()
    }
  }
}

private struct RestaurantRow: View {
  let restaurant: Restaurant

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(restaurant.name)
          .font(.headline)
        Text(restaurant.address)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      Spacer()
      Text(String(format: "%.1f★", restaurant.rating))
        .font(.footnote)
        .padding(6)
        .background(Capsule().fill(Color.yellow.opacity(0.2)))
    }
    .padding(.vertical, 4)
  }
}

#Preview {
  NavigationStack {
    RestaurantListView(viewModel: RestaurantViewModel())
  }
}
