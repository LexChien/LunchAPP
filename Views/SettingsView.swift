import SwiftUI

struct SettingsView: View {
  @ObservedObject var viewModel: SettingsViewModel
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    Form {
      Section("Preferred Group") {
        Picker("Group", selection: $viewModel.preference.group) {
          ForEach(UserPreference.Group.allCases, id: \.self) { group in
            Text(label(for: group)).tag(group)
          }
        }
        .pickerStyle(.segmented)
      }

      Section("Price Level") {
        Stepper(value: priceLowerBinding, in: 1...4) {
          Text("Minimum: \(viewModel.preference.priceLevelRange.lowerBound)")
        }
        Stepper(value: priceUpperBinding, in: 1...4) {
          Text("Maximum: \(viewModel.preference.priceLevelRange.upperBound)")
        }
      }

      Section("Keywords") {
        TextField("e.g. sushi, vegan", text: keywordsBinding)
      }
    }
    .navigationTitle("Settings")
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("Done") { dismiss() }
      }
    }
  }

  private var priceLowerBinding: Binding<Int> {
    Binding(
      get: { viewModel.preference.priceLevelRange.lowerBound },
      set: { newValue in
        let upper = max(newValue, viewModel.preference.priceLevelRange.upperBound)
        viewModel.updatePriceLevel(range: newValue...upper)
      }
    )
  }

  private var priceUpperBinding: Binding<Int> {
    Binding(
      get: { viewModel.preference.priceLevelRange.upperBound },
      set: { newValue in
        let lower = min(newValue, viewModel.preference.priceLevelRange.lowerBound)
        viewModel.updatePriceLevel(range: lower...newValue)
      }
    )
  }

  private var keywordsBinding: Binding<String> {
    Binding(
      get: { viewModel.preference.keywords.joined(separator: ", ") },
      set: { viewModel.updateKeywords($0.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }) }
    )
  }

  private func label(for group: UserPreference.Group) -> String {
    switch group {
    case .student: "學生"
    case .office: "上班族"
    case .vegetarian: "素食者"
    }
  }
}

#Preview {
  NavigationStack {
    SettingsView(viewModel: SettingsViewModel())
  }
}
