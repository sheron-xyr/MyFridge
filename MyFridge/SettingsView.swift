//
//  FunFactsView.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/18.
//

import SwiftUI

class GlobalSettings: ObservableObject {
    @Published var settings = Settings(showEnergy: true, showWater: true, showCarbohydrate: false, showSugars: false, showProtein: false, showFat: false, daysUntilNearExpiration: 3)
}

struct SettingsView: View {
    @ObservedObject var globalSettings = GlobalSettings()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expiration Settings")) {
                    Stepper(value: $globalSettings.settings.daysUntilNearExpiration, in: 1...30) {
                        Text("Days until near expiration: \(globalSettings.settings.daysUntilNearExpiration)")
                    }
                }
                Section(header: Text("Nutrition Display")) {
                    Toggle("Show Energy", isOn: $globalSettings.settings.showEnergy)
                    Toggle("Show Water", isOn: $globalSettings.settings.showWater)
                    Toggle("Show Carbohydrate", isOn: $globalSettings.settings.showCarbohydrate)
                    Toggle("Show Sugars", isOn: $globalSettings.settings.showSugars)
                    Toggle("Show Protein", isOn: $globalSettings.settings.showProtein)
                    Toggle("Show Fat", isOn: $globalSettings.settings.showFat)
                }
                Section {
                    Button(action: {
                        NotificationCenter.default.post(name: Notification.Name("SettingsUpdated"), object: nil)
                    }) {
                        Text("Save Settings")
                    }
                }
            }
          .navigationTitle("Settings")
        }
    }
}
