//
//  RecipeDetailPage.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/12.
//

import SwiftUI

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

//#Preview {
//    RecipeDetailPage()
//}
