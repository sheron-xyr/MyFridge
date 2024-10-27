//
//  FunFactsView.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/18.
//

import SwiftUI
import SwiftData


struct SettingsView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var userSetting: UserSettings
    
    var body: some View {
        NavigationView {
                Form {
                Section(header: Text("Expiration Settings")) {
                    Stepper(value: $userSetting.daysUntilNearExpiration, in: 1...30) {
                        Text("Days until near expiration: \(userSetting.daysUntilNearExpiration)")
                    }
                }
                Section(header: Text("Nutrition Display")) {
                    Toggle("Show Energy", isOn: $userSetting.showEnergy)
                    Toggle("Show Water", isOn: $userSetting.showWater)
                    Toggle("Show Carbohydrate", isOn: $userSetting.showCarbohydrate)
                    Toggle("Show Sugars", isOn: $userSetting.showSugars)
                    Toggle("Show Protein", isOn: $userSetting.showProtein)
                    Toggle("Show Fat", isOn: $userSetting.showFat)
                }
                Section {
                    Button(action: {
                        try? modelContext.save()
                        //                        NotificationCenter.default.post(name: Notification.Name("SettingsUpdated"), object: nil)
                    }) {
                        Text("Save Settings")
                    }
                }
            }
          .navigationTitle("Settings")
          
        }
    }
}
