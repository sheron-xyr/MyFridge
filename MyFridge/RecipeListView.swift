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
//    @State private var searchText = ""
//    @State private var showOnlyFavorites = false
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
//                TextField("Search", text: $searchText)
//                   .padding()
//                   .background(Color(.systemGray6))
//                   .cornerRadius(8)

//                Toggle(isOn: $showOnlyFavorites) {
//                    Text("Only Favorites")
//                }
//               .padding()

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
//            Text(recipe.name)
//               .font(.title)
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
                Text("Energy: \(String(format: "%.1f", recipe.nutrition.energy)) kcal")
            }
            if setting.showWater {
                Text("Water: \(String(format: "%.1f", recipe.nutrition.water)) g")
            }
            if setting.showCarbohydrate {
                Text("Carbohydrate: \(String(format: "%.1f", recipe.nutrition.carbohydrate)) g")
            }
            if setting.showSugars {
                Text("Sugars: \(String(format: "%.1f", recipe.nutrition.sugars)) g")
            }
            if setting.showProtein {
                Text("Protein: \(String(format: "%.1f", recipe.nutrition.protein)) g")
            }
            if setting.showFat {
                Text("Fat: \(String(format: "%.1f", recipe.nutrition.fat)) g")
            }
            Toggle("Favorite", isOn: $recipe.isFavorite)
        }
       .padding()
       .navigationTitle(recipe.name)
    }
}
