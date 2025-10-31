import SwiftUI

struct FilterSheetView: View {
  @ObservedObject var viewModel: SettingsViewModel

  var body: some View {
    Form {
      Section("Group") {
        Picker("Group", selection: $viewModel.preference.group) {
          ForEach(UserPreference.Group.allCases, id: \.self) { group in
            Text(groupTitle(group)).tag(group)
          }
        }
        .pickerStyle(.segmented)
      }

      Section("Radius") {
        Slider(value: radiusBinding, in: 500...3000, step: 100) {
          Text("Radius")
        } minimumValueLabel: {
          Text("500m")
        } maximumValueLabel: {
          Text("3000m")
        }
        Text("\(Int(viewModel.preference.radiusInMeters)) meters")
          .font(.footnote)
          .foregroundStyle(.secondary)
      }

      Section("Keywords") {
        TextField("Comma separated", text: keywordsBinding)
      }
    }
    .navigationTitle("Filters")
  }

  private var radiusBinding: Binding<Double> {
    Binding(
      get: { viewModel.preference.radiusInMeters },
      set: { viewModel.updateRadius($0) }
    )
  }

  private var keywordsBinding: Binding<String> {
    Binding(
      get: { viewModel.preference.keywords.joined(separator: ", ") },
      set: { viewModel.updateKeywords($0.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }) }
    )
  }

  private func groupTitle(_ group: UserPreference.Group) -> String {
    switch group {
    case .student: "學生"
    case .office: "上班族"
    case .vegetarian: "素食者"
    }
  }
}

#Preview {
  NavigationStack {
    FilterSheetView(viewModel: SettingsViewModel())
  }
}
