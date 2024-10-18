//
//  StoryView.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/18.
//

import SwiftUI


struct FoodListView: View {
    @State private var searchText = ""
    @State private var sortOption = SortOption.expirationDate
    @State private var foodData : [Food] = foodList
    
    enum SortOption {
        case expirationDate
        case foodName
        }
    
    var sortedFoods: [Food] {
        var foods = foodData
        switch sortOption {
        case.expirationDate:
            foods.sort { $0.expirationDaysLeft < $1.expirationDaysLeft }
        case.foodName:
            foods.sort { $0.name < $1.name }
        }
        return foods
    }
    
    var filteredFoods: [Food] {
        return sortedFoods.filter { food in
            searchText.isEmpty || food.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Search Bar
                TextField("Search", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                // Sorting Method
                Picker("Sort by", selection: $sortOption) {
                    Text("Expiration Date (Near to Far)").tag(SortOption.expirationDate)
                    Text("Food Name (Alphabetical)").tag(SortOption.foodName)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List(filteredFoods) { food in
                    HStack {
                        if let imageName = food.imageName {
                            Image(imageName)
                                .resizable()
                                .frame(width: 50, height: 50)
                        } else {
                            Image(systemName: "photo.badge.plus")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
//                        VStack(alignment:.leading) {
                            Text(food.name)
                            if food.isNearExpiration {
                                Text("\(food.expirationDaysLeft) days left")
                                    .foregroundColor(.red)
                            } else {
                                Text("\(food.expirationDaysLeft) days left")
                            }
//                        }
//                        Spacer()
                        Text("quantity: \(food.quantity) pieces")
                        NavigationLink(value: food) {
//                            Image(systemName: "chevron.right")
                        }
                    }
                }

                NavigationLink(destination: AddFoodView()) {
                    Text("Add Food")
                        .frame(maxWidth:.infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Food List")
            .navigationDestination(for: Food.self) { food in
                FoodDetailView(food: food)
            }
        }
    }
}


struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView()
    }
}
