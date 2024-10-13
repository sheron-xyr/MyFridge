//
//  FoodDetailPage.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/12.
//

import SwiftUI

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

//#Preview {
//    FoodDetailPage()
//}
