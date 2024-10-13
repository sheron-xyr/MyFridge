//
//  ContentView.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/11.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    var body: some View {
        TabView(selection: $selectedTab) {
            HomePage(selectedTab: $selectedTab)
              .tabItem {
                    Label("Home", systemImage: "house")
                }
              .tag(Tab.home)
            FoodListPage(selectedTab: $selectedTab)
              .tabItem {
                    Label("Food List", systemImage: "list.bullet")
                }
              .tag(Tab.foodList)
            RecipeListPage(selectedTab: $selectedTab)
              .tabItem {
                    Label("Recipe List", systemImage: "book")
                }
              .tag(Tab.recipeList)
        }
    }
}

enum Tab {
    case home
    case foodList
    case recipeList
    case addFood
    case settings
}

struct HomePage: View {
    @Binding var selectedTab: Tab
    var body: some View {
        VStack {
            Image(systemName: "leaf")
              .resizable()
              .aspectRatio(contentMode:.fit)
              .frame(width: 100, height: 100)
            HStack {
                Button(action: {
                    selectedTab = .foodList
                }) {
                    Text("Food List")
                }
                Button(action: {
                    selectedTab = .recipeList
                }) {
                    Text("Recipe List")
                }
            }
            Spacer()
            NavigationLink(destination: SettingsPage()) {
                Image(systemName: "gear")
            }
        }
    }
}

struct FilterOptions {
    enum FilterType {
        case expirationDate
        case foodName
        case onlyNearExpiration
    }
    var filterType: FilterType = .expirationDate
}

struct Food:Identifiable {
    let id=UUID()
    let name: String
    let expirationDate: String
    let quantity: Int
    let isNearExpiration: Bool
    let expirationDaysLeft: Int
    let imageName: String
    let nutrition: Nutrition?
    let recipes: [Recipe]
}

struct Recipe:Identifiable {
    let id=UUID()
    let name: String
    let imageName: String
    let ingredients: [Ingredient]
    let steps: [String]
    let nutrition: Nutrition?
}

struct Ingredient:Identifiable {
    let id=UUID()
    let name: String
}

struct Nutrition {
    let calories: Int
}

let settings = Settings(showCalories: true)

var foodData = [
    Food(name: "Banana", expirationDate: "2024-10-15", quantity: 2, isNearExpiration: true, expirationDaysLeft: 3, imageName: "banana", nutrition: Nutrition(calories: 100), recipes: [Recipe(name: "Banana Milkshake", imageName: "milkshake", ingredients: [], steps: [], nutrition: nil), Recipe(name: "Banana Pancakes", imageName: "pancakes", ingredients: [], steps: [], nutrition: nil)]),
    Food(name: "Eggplant", expirationDate: "2024-10-20", quantity: 5, isNearExpiration: false, expirationDaysLeft: 8, imageName: "eggplant", nutrition: nil, recipes: []),
    Food(name: "Beef", expirationDate: "2024-10-18", quantity: 3, isNearExpiration: false, expirationDaysLeft: 6, imageName: "beef", nutrition: Nutrition(calories: 200), recipes: [])
]

let recipeData = [
    Recipe(name: "Favorite Recipe", imageName: "recipe", ingredients: [], steps: [], nutrition: nil),
    Recipe(name: "Another Recipe", imageName: "recipe", ingredients: [], steps: [], nutrition: nil)
]

struct PreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        TabView(selection: Binding.constant(Tab.home)) {
            HomePage(selectedTab: Binding.constant(Tab.home))
            FoodListPage(selectedTab: Binding.constant(Tab.foodList))
            RecipeListPage(selectedTab: Binding.constant(Tab.recipeList))
            SettingsPage()
            FoodDetailPage(selectedTab: Binding.constant(Tab.foodList), food: foodData[0])
            AddFoodPage(selectedTab: Binding.constant(Tab.addFood))
            RecipeDetailPage(selectedTab: Binding.constant(Tab.recipeList), recipe: recipeData[0])
        }
    }
}
