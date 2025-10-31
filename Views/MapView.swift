import SwiftUI
import MapKit
import CoreLocation

struct RestaurantMapView: View {
  let coordinate: CLLocationCoordinate2D

  @State private var region: MKCoordinateRegion
  @State private var locations: [RestaurantLocation]

  init(coordinate: CLLocationCoordinate2D) {
    self.coordinate = coordinate
    let initialRegion = MKCoordinateRegion(
      center: coordinate,
      span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    _region = State(initialValue: initialRegion)
    _locations = State(initialValue: [RestaurantLocation(coordinate: coordinate)])
  }

  var body: some View {
    mapContent
      .onChange(of: coordinate) { newValue in
        region = MKCoordinateRegion(
          center: newValue,
          span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        locations = [RestaurantLocation(coordinate: newValue)]
      }
  }

  @ViewBuilder
  private var mapContent: some View {
    if #available(iOS 17, *) {
      Map(initialPosition: .region(region)) {
        Marker("Restaurant", coordinate: coordinate)
      }
    } else {
      Map(coordinateRegion: $region, annotationItems: locations) { location in
        MapMarker(coordinate: location.coordinate, tint: .red)
      }
    }
  }

  private struct RestaurantLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
  }
}

#Preview {
  RestaurantMapView(coordinate: CLLocationCoordinate2D(latitude: 25.0330, longitude: 121.5654))
    .frame(height: 200)
}
