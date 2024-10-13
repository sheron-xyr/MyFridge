//
//  FoodListPage.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/12.
//
import SwiftUI

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
