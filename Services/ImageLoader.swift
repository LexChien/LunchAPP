import Foundation
import SwiftUI
import UIKit

protocol ImageLoading {
  func image(for reference: String?) async -> Image?
}

final class ImageLoader: ImageLoading {
  private let cache = NSCache<NSString, UIImage>()

  func image(for reference: String?) async -> Image? {
    guard let reference else { return nil }

    if let cached = cache.object(forKey: reference as NSString) {
      return Image(uiImage: cached)
    }

    // Placeholder image until the Places Photo API integration lands.
    if let placeholder = UIImage(systemName: "fork.knife") {
      cache.setObject(placeholder, forKey: reference as NSString)
      return Image(uiImage: placeholder)
    }

    return nil
  }
}

struct MockImageLoader: ImageLoading {
  func image(for reference: String?) async -> Image? {
    Image(systemName: "photo")
  }
}
