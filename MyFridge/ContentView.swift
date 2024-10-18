//
//  ContentView.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }


            FoodListView()
                .tabItem {
                    Label("Food List", systemImage: "list.bullet")
                }
            
            RecipeListView()
                .tabItem {
                    Label("Recipe List", systemImage: "book")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//struct ContentView: View {
////    @State private var selectedTab: Tab = .home
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            HomePage(selectedTab: $selectedTab)
//              .tabItem {
//                    Label("Home", systemImage: "house")
//                }
//              .tag(Tab.home)
//            FoodListPage(selectedTab: $selectedTab)
//              .tabItem {
//                    Label("Food List", systemImage: "list.bullet")
//                }
//              .tag(Tab.foodList)
//            RecipeListPage(selectedTab: $selectedTab)
//              .tabItem {
//                    Label("Recipe List", systemImage: "book")
//                }
//              .tag(Tab.recipeList)
//        }
//    }
//}
//
//enum Tab {
//    case home
//    case foodList
//    case recipeList
//    case addFood
//    case settings
//}
//
//struct HomePage: View {
//    @Binding var selectedTab: Tab
//    var body: some View {
//        VStack {
//            Image(systemName: "leaf")
//              .resizable()
//              .aspectRatio(contentMode:.fit)
//              .frame(width: 100, height: 100)
//            HStack {
//                Button(action: {
//                    selectedTab = .foodList
//                }) {
//                    Text("Food List")
//                }
//                Button(action: {
//                    selectedTab = .recipeList
//                }) {
//                    Text("Recipe List")
//                }
//            }
//            Spacer()
//            NavigationLink(destination: SettingsPage()) {
//                Image(systemName: "gear")
//            }
//        }
//    }
//}
//

//
//struct PreviewProvider_Previews: PreviewProvider {
//    static var previews: some View {
//        TabView(selection: Binding.constant(Tab.home)) {
//            HomePage(selectedTab: Binding.constant(Tab.home))
//            FoodListPage(selectedTab: Binding.constant(Tab.foodList))
//            RecipeListPage(selectedTab: Binding.constant(Tab.recipeList))
//            SettingsPage()
////            FoodDetailPage(selectedTab: Binding.constant(Tab.foodList), food: foodData[0])
//            AddFoodPage(selectedTab: Binding.constant(Tab.addFood))
////            RecipeDetailPage(selectedTab: Binding.constant(Tab.recipeList), recipe: recipeData[0])
//        }
//    }
//}
