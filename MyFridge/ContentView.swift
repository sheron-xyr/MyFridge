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

struct FoodListPage: View {
    @Binding var selectedTab: Tab
    @State var searchText = ""
    @State var filterOptions = FilterOptions()

    var body: some View {
        VStack {
            TextField("Search by food name", text: $searchText)
            Picker("Filter options", selection: $filterOptions.filterType) {
                Text("Expiration date").tag(FilterOptions.FilterType.expirationDate)
                Text("Food name").tag(FilterOptions.FilterType.foodName)
                Text("Only near expiration").tag(FilterOptions.FilterType.onlyNearExpiration)
            }
            List(foodData) { food in
                if filterOptions.filterType == .expirationDate && !isFoodMatchingExpirationDate(food) {
                    EmptyView()
                } else if filterOptions.filterType == .foodName && !isFoodMatchingName(food) {
                    EmptyView()
                } else if filterOptions.filterType == .onlyNearExpiration && !food.isNearExpiration {
                    EmptyView()
                } else {
                    NavigationLink(destination: FoodDetailPage(selectedTab: $selectedTab, food: food)) {
                        HStack {
                            Image(systemName: food.imageName)
                            Text(food.name)
                            if food.isNearExpiration {
                                Text("\(food.expirationDaysLeft) days left").foregroundColor(.red)
                            } else {
                                Text("\(food.expirationDaysLeft) days left").foregroundColor(.black)
                            }
                            Text("\(food.quantity)")
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
            HStack {
                Button(action: {
                    selectedTab = .home
                }) {
                    Image(systemName: "chevron.left")
                }
                Button(action: {
                    // Navigate to add food page
                    selectedTab = .addFood
                }) {
                    Image(systemName: "plus")
                }
                Button(action: {
                    selectedTab = .home
                }) {
                    Image(systemName: "house")
                }
            }
        }
    }

    func isFoodMatchingExpirationDate(_ food: Food) -> Bool {
        // Implement expiration date filtering logic
        return true
    }

    func isFoodMatchingName(_ food: Food) -> Bool {
        // Implement food name filtering logic
        return true
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

struct FoodDetailPage: View {
    @Binding var selectedTab: Tab
    let food: Food

    var body: some View {
        VStack {
            Image(systemName: food.imageName)
            Text(food.name)
            Text("Expiration date: \(food.expirationDate)")
            Text("Quantity: \(food.quantity)")
            if let nutrition = food.nutrition {
                if settings.showCalories {
                    Text("Calories: \(nutrition.calories)")
                }
            }
            Text("Recipes:")
            ForEach(food.recipes.prefix(3)) { recipe in
                NavigationLink(destination: RecipeListPage(selectedTab: $selectedTab, searchText: food.name)) {
                    Text(recipe.name)
                }
            }
            HStack {
                Button(action: {
                    selectedTab = .foodList
                }) {
                    Image(systemName: "chevron.left")
                }
                Button(action: {
                    // Navigate to edit page
                }) {
                    Image(systemName: "pencil")
                }
                Button(action: {
                    selectedTab = .home
                }) {
                    Image(systemName: "house")
                }
            }
        }
    }
}

struct AddFoodPage: View {
    @Binding var selectedTab: Tab
    @State var capturedImage: Image?
    @State var recognizedFoodName: String = ""
    @State var expirationDate: String = ""
    @State var quantity: Int = 1

    var body: some View {
        VStack {
            if let image = capturedImage {
                image
                  .resizable()
                  .aspectRatio(contentMode:.fit)
            }
            Text(recognizedFoodName)
            Text(expirationDate)
            Text("Quantity: \(quantity)")
            HStack {
                Button(action: {
                    selectedTab = .foodList
                }) {
                    Text("Cancel")
                }
                Button(action: {
                    // Add food and go back to food list page
                    let newFood = Food(name: recognizedFoodName, expirationDate: expirationDate, quantity: quantity, isNearExpiration: false, expirationDaysLeft: 0, imageName: "apple", nutrition: nil, recipes: [])
                    foodData.append(newFood)
                    selectedTab = .foodList
                }) {
                    Text("Add")
                }
            }
        }
    }
}

struct RecipeListPage: View {
    @Binding var selectedTab: Tab
    @State var searchText = ""
    @State var recipes = recipeData

    var body: some View {
        VStack {
            TextField("Search by recipe name", text: $searchText)
            List(recipes) { recipe in
                NavigationLink(destination: RecipeDetailPage(selectedTab: $selectedTab, recipe: recipe)) {
                    Text(recipe.name)
                }
            }
            HStack {
                Button(action: {
                    selectedTab = .home
                }) {
                    Image(systemName: "chevron.left")
                }
                Button(action: {
                    selectedTab = .home
                }) {
                    Image(systemName: "house")
                }
            }
        }
    }
}

struct RecipeDetailPage: View {
    @Binding var selectedTab: Tab
    let recipe: Recipe

    var body: some View {
        VStack {
            Image(systemName: recipe.imageName)
            Text(recipe.name)
            Text("Ingredients:")
            ForEach(recipe.ingredients) { ingredient in
                Text(ingredient.name)
            }
            Text("Steps:")
            // ForEach(recipe.steps, id: UUID()) { step in
             //   Text(step)
          //  }
            if let nutrition = recipe.nutrition {
                if settings.showCalories {
                    Text("Calories: \(nutrition.calories)")
                }
            }
            HStack {
                Button(action: {
                    selectedTab = .recipeList
                }) {
                    Image(systemName: "chevron.left")
                }
                Button(action: {
                    // Mark as favorite
                }) {
                    Image(systemName: "heart")
                }
                Button(action: {
                    selectedTab = .home
                }) {
                    Image(systemName: "house")
                }
            }
        }
    }
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

struct Settings {
    var showCalories: Bool
}

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
