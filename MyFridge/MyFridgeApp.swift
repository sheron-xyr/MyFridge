//
//  MyFridgeApp.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/11.
//

import SwiftUI

@main
struct MyFridgeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [UserSettings.self, Nutrition.self, Food.self, Recipe.self])
        
    }
}
