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
    @Query var recipeList: [Recipe]
    @Query var foodList: [Food]
    
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            NavigationStack {
                FoodListView(sort: foodSortOrder, searchText: foodSearchText)
                    .toolbar {
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
                    
            }
            .searchable(text: $foodSearchText)
            .tabItem {
                Label("Food List", systemImage: "list.bullet")
            }
            
            NavigationStack{
                RecipeListView(searchString: recipeSearchText, showFavoriteOnly: showOnlyFavorites)
                    
                    .toolbar {
                        ToolbarItem(placement:.navigationBarTrailing) {
                            Toggle(isOn: $showOnlyFavorites) {
                                Text("Only Favorites")
                            }
                        }
                    }
            }
            .searchable(text: $recipeSearchText)
                .tabItem {
                    Label("Recipe List", systemImage: "book")
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
            if userSettings.isEmpty {
                let defaultSettings = UserSettings()
                modelContext.insert(defaultSettings)
                try? modelContext.save()
            }
        }
    }
}
