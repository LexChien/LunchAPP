import SwiftUI
import MapKit
import CoreLocation

struct RestaurantDetailView: View {
  @ObservedObject var viewModel: DetailViewModel
  var imageLoader: ImageLoading = ImageLoader()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        headerSection
        infoSection
        mapSection
      }
      .padding()
    }
    .navigationTitle(viewModel.restaurant.name)
    .toolbar {
      Button(action: viewModel.toggleFavorite) {
        Label("Favorite", systemImage: viewModel.isFavorite ? "heart.fill" : "heart")
      }
    }
  }

  @ViewBuilder
  private var headerSection: some View {
    AsyncImage(url: previewURL) { phase in
      switch phase {
      case .empty:
        ProgressView()
      case let .success(image):
        image
          .resizable()
          .scaledToFill()
      case .failure:
        Image(systemName: "fork.knife")
          .font(.largeTitle)
          .frame(maxWidth: .infinity, minHeight: 180)
      @unknown default:
        EmptyView()
      }
    }
    .frame(height: 220)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }

  private var infoSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(viewModel.restaurant.address)
        .font(.subheadline)
        .foregroundStyle(.secondary)
      Text("Rating: \(String(format: "%.1f", viewModel.restaurant.rating))")
      if let price = viewModel.restaurant.priceLevel {
        Text("Price level: \(String(repeating: "$", count: price))")
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  @ViewBuilder
  private var mapSection: some View {
    if let coordinate = viewModel.restaurant.coordinate {
      RestaurantMapView(coordinate: coordinate)
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
  }

  private var previewURL: URL? {
    guard let reference = viewModel.restaurant.photoReference else { return nil }
    return URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)")
  }
}

#Preview {
  NavigationStack {
    RestaurantDetailView(viewModel: DetailViewModel(restaurant: .placeholder))
  }
}
