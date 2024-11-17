//
//  FavoratesView.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/18.
//

import SwiftUI
import SwiftData

struct RecipeListView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Recipe.name)]) var recipeList: [Recipe]
    @Query var userSettings: [UserSettings]

    init(searchString: String, showFavoriteOnly: Bool) {
            _recipeList = Query(filter: #Predicate {
                if showFavoriteOnly {
                    return $0.isFavorite && (searchString.isEmpty || $0.name.localizedStandardContains(searchString))
                    
                } else {
                    return searchString.isEmpty || $0.name.localizedStandardContains(searchString)
                }
            })
        }

    var body: some View {
        NavigationStack {
            VStack {

                List {
                    ForEach(recipeList) { recipe in
                        HStack {
                            if let imageData = recipe.image, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            } else {
                                Image(systemName: "photo.badge.plus")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                            Text(recipe.name)
                            Spacer()
                            NavigationLink(value: recipe){
                            }
                        }
                    }
                    .onDelete(perform: deleteRecipes)
                }
                NavigationLink(destination: AddRecipeView()) {
                    Text("Add Recipe")
                        .frame(maxWidth:.infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
           .navigationTitle("Recipe List")
           .navigationDestination(for: Recipe.self) { recipe in
               RecipeDetailView(recipe: recipe)
           }
        }
    }
    func deleteRecipes(_ indexSet: IndexSet) {
        for index in indexSet {
            let recipe = recipeList[index]
            modelContext.delete(recipe)
        }
    }
}

struct RecipeDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var recipe : Recipe
    @Query var userSettings: [UserSettings]

    var body: some View {
        let setting : UserSettings = userSettings.first!
        VStack(alignment:.leading) {
            if let imageData = recipe.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 300, height: 300)
            } else {
                Image(systemName: "photo.badge.plus")
                   .resizable()
                   .frame(width: 300, height: 300)
            }
            Text("Ingredients: \(recipe.ingredients)")
            Text("Steps: \(recipe.steps)")
            if setting.showEnergy {
                if recipe.nutrition.energy != -1 {
                    Text("Energy: \(String(format: "%.1f", recipe.nutrition.energy)) kcal")
                }
                else {
                    Text("Energy: unknown")
                }
            }
            if setting.showWater {
                if recipe.nutrition.water != -1 {
                    Text("Water: \(String(format: "%.1f", recipe.nutrition.water)) g")
                }
                else {
                    Text("Water: unknown")
                }
            }
            if setting.showCarbohydrate {
                if recipe.nutrition.carbohydrate != -1 {
                    Text("Carbohydrate: \(String(format: "%.1f", recipe.nutrition.carbohydrate)) g")
                }
                else {
                    Text("Carbohydrate: unknown")
                }
            }
            if setting.showSugars {
                if recipe.nutrition.sugars != -1 {
                    Text("Sugars: \(String(format: "%.1f", recipe.nutrition.sugars)) g")
                }
                else {
                    Text("Sugars: unknown")
                }
            }
            if setting.showProtein {
                if recipe.nutrition.protein != -1 {
                    Text("Protein: \(String(format: "%.1f", recipe.nutrition.protein)) g")
                }
                else {
                    Text("Protein: unknown")
                }
                
            }
            if setting.showFat {
                if recipe.nutrition.fat != -1 {
                    Text("Fat: \(String(format: "%.1f", recipe.nutrition.fat)) g")
                }
                else {
                    Text("Fat: unknown")
                }
            }
            Toggle("Favorite", isOn: $recipe.isFavorite)
        }
       .padding()
       .navigationTitle(recipe.name)
    }
}
