//
//  ContentView.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/11.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var foodSortOrder = SortDescriptor(\Food.expirationDate)
    @State private var foodSearchText = ""
    @State private var recipeSearchText = ""
    @State private var showOnlyFavorites = false
    @Environment(\.modelContext) var modelContext
    @Query var userSettings: [UserSettings]
    
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            
            FoodListView(sort: foodSortOrder, searchText: foodSearchText)
                .tabItem {
                    //TODO: this label is invisible but clickable
                    Label("Food List", systemImage: "list.bullet")
                }
            // search bar
                .searchable(text: $foodSearchText)
                .toolbar {
                    // TODO: this picker is missing
                    ToolbarItem(placement:.navigationBarTrailing) {
                        Picker("Sort", selection: $foodSortOrder) {
                            Text("Expiration Date (Near to Far)")
                                .tag(SortDescriptor(\Food.expirationDate))
                            
                            Text("Food Name (Alphabetical)")
                                .tag(SortDescriptor(\Food.name))
                        }
                        .pickerStyle(.inline)
                    }
                }
            
            RecipeListView(searchString: recipeSearchText, showFavoriteOnly: showOnlyFavorites)
                .tabItem {
                    //TODO: this label is invisible but clickable
                    Label("Recipe List", systemImage: "book")
                }
                .searchable(text: $recipeSearchText)
                .toolbar {
                    // TODO: this toggle is missing
                    ToolbarItem(placement:.navigationBarTrailing) {
                        Toggle(isOn: $showOnlyFavorites) {
                            Text("Only Favorites")
                        }
                    }
                }
            
            
            if let firstUserSetting = userSettings.first {
                SettingsView(userSetting: firstUserSetting)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            } else {
                Text("Loading settings...")
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
        .onAppear {
            // TODO: cannot ensure it happens before the setting data is needed
            if userSettings.isEmpty {
                let defaultSettings = UserSettings()
                modelContext.insert(defaultSettings)
                try? modelContext.save()
            }
        }
    }
}
