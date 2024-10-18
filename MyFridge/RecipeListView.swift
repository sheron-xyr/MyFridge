//
//  FavoratesView.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/18.
//

import SwiftUI

struct RecipeListView: View {
    @State private var searchText = ""
    @State private var showOnlyFavorites = false
    @State private var recipeData : [Recipe] = recipeList

    var filteredRecipes: [Recipe] {
        var allRecipes = recipeData
        if showOnlyFavorites {
            allRecipes = allRecipes.filter { $0.isFavorite }
        }
        return allRecipes.filter { recipe in
            searchText.isEmpty || recipe.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search", text: $searchText)
                   .padding()
                   .background(Color(.systemGray6))
                   .cornerRadius(8)

                Toggle(isOn: $showOnlyFavorites) {
                    Text("Only Favorites")
                }
               .padding()

                List(filteredRecipes) { recipe in
                    HStack {
                        if let imageName = recipe.imageName{
                            Image(imageName)
                               .resizable()
                               .frame(width: 50, height: 50)
                        } else {
                            Image(systemName: "photo.badge.plus")
                               .resizable()
                               .frame(width: 50, height: 50)
                        }
                        Text(recipe.name)
                        Spacer()
                        NavigationLink(destination: RecipeDetailView(recipe: Binding(get: { recipe }, set: { newValue in
                                                    if let index = recipeList.firstIndex(where: { $0.id == recipe.id }) {
                                                        recipeList[index] = newValue
                                                    }
                                                }))) {
                        }
                    }
                }
            }
           .navigationTitle("Recipe List")
        }
    }
}

struct RecipeDetailView: View {
    @Binding var recipe : Recipe

    var body: some View {
        VStack(alignment:.leading) {
//            Text(recipe.name)
//               .font(.title)
            if let imageName = recipe.imageName {
                Image(imageName)
                   .resizable()
                   .frame(width: 150, height: 150)
            } else {
                Image(systemName: "photo.badge.plus")
                   .resizable()
                   .frame(width: 150, height: 150)
            }
            Text("Ingredients:")
            ForEach(Array(zip(recipe.ingredients.indices, recipe.ingredients)), id: \.1) { index, ingredient in
                Text("- \(ingredient)")
            }
            Text("Steps:")
            ForEach(Array(zip(recipe.steps.indices, recipe.steps)), id: \.1) { index, step in
                Text("\(step)")
            }
            if settings.showEnergy {
                Text("Energy: \(recipe.nutrition.energy) kcal")
            }
            if settings.showWater {
                Text("Water: \(recipe.nutrition.water) g")
            }
            if settings.showCarbohydrate {
                Text("Carbohydrate: \(recipe.nutrition.carbohydrate) g")
            }
            if settings.showSugars {
                Text("Sugars: \(recipe.nutrition.sugars) g")
            }
            if settings.showProtein {
                Text("Protein: \(recipe.nutrition.protein) g")
            }
            if settings.showFat {
                Text("Fat: \(recipe.nutrition.fat) g")
            }
//            Toggle(isOn: $recipe.isFavorite) {
//                Text("Favorite")
//            }
            Toggle("Favorite", isOn: $recipe.isFavorite)
        }
       .padding()
       .navigationTitle(recipe.name)
    }
}


struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
