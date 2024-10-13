//
//  RecipeListPage.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/12.
//

import SwiftUI

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

//#Preview {
//    RecipeListPage()
//}
