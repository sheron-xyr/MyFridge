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
                
                // search bar
                    .searchable(text: $foodSearchText)
                    .toolbar {
                        ToolbarItemGroup(placement:.navigationBarTrailing) {
                            Picker("Sort", selection: $foodSortOrder) {
                                Text("Expiration Date (Near to Far)")
                                    .tag(SortDescriptor(\Food.expirationDate))
                                
                                Text("Food Name (Alphabetical)")
                                    .tag(SortDescriptor(\Food.name))
                            }
                            .pickerStyle(.inline)
                        }
                    }
                    
            }.tabItem {
                Label("Food List", systemImage: "list.bullet")
            }
            
            NavigationStack{
            RecipeListView(searchString: recipeSearchText, showFavoriteOnly: showOnlyFavorites)
                
                .searchable(text: $recipeSearchText)
                .toolbar {
                    ToolbarItem(placement:.navigationBarTrailing) {
                        Toggle(isOn: $showOnlyFavorites) {
                            Text("Only Favorites")
                        }
                    }
                }}
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
            if foodList.isEmpty {
                let food1 = Food(name: "apple", expirationDate: Date(), quantity: 1, unit: "piece")
                modelContext.insert(food1)
                try? modelContext.save()
            }
            if recipeList.isEmpty {
                let recipe1 = Recipe(name: "Banana Smoothie", steps: "Peel and slice the bananas.\n Put the bananas, milk, yogurt, and honey in a blender.\n Blend until smooth.", nutrition: Nutrition(energy: 250, water: 75.11, carbohydrate: 40.0, sugars: 30, protein: 5, fat: 5), isFavorite: true, ingredients: "banana\n milk")
                let recipe2 = Recipe(name: "Banana Pancake", steps: "In a large bowl, combine the flour, sugar, baking powder, and salt.\n In a separate bowl, beat the egg. Add the milk and melted butter and stir to combine.\n Pour the wet ingredients into the dry ingredients and stir until just combined. Do not overmix.", nutrition: Nutrition(energy: 300, water: 40, carbohydrate: 50.0, sugars: 15, protein: 8, fat: 10), isFavorite: false, ingredients: "banana\n butter\n flour")
                modelContext.insert(recipe1)
                modelContext.insert(recipe2)
                try? modelContext.save()
            }
        }
    }
}
