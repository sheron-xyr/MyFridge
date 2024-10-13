//
//  SettingsPage.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/12.
//

import SwiftUI

struct SettingsPage: View {
    var body: some View {
        VStack {
            TextField("Days before expiration considered near expiration", text:.constant("3"))
            Picker("Nutrition components", selection:.constant("Calories")) {
                Text("Carbohydrates").tag("Carbohydrates")
                Text("Protein").tag("Protein")
                Text("Fat").tag("Fat")
                Text("Calories").tag("Calories")
                Text("Trace elements").tag("Trace elements")
            }
            TextField("Daily calorie intake limit", text:.constant("2000"))
            Picker("Cuisine preference", selection:.constant("Chinese")) {
                Text("Chinese").tag("Chinese")
                Text("Japanese").tag("Japanese")
            }
        }
    }
}

struct Settings {
    var showCalories: Bool
}
