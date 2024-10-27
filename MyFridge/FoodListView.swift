//
//  StoryView.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/18.
//

import SwiftUI
import SwiftData


struct FoodListView: View {
    @Environment(\.modelContext) var modelContext
//    @State private var searchText = ""
//    @State private var sortOrder = SortDescriptor(\Food.expirationDate)
    @Query(sort: [SortDescriptor(\Food.expirationDate), SortDescriptor(\Food.name)]) var foodList: [Food]
    @Query var userSettings: [UserSettings]
    
    init(sort: SortDescriptor<Food>, searchText: String) {
            _foodList = Query(filter: #Predicate {
                if searchText.isEmpty {
                    return true
                } else {
                    return $0.name.localizedStandardContains(searchText)
                }
            }, sort: [sort])
        }

    
    
    var body: some View {
        NavigationStack {
            VStack {
                // Search Bar
//                TextField("Search", text: $searchText)
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(8)
                // Sorting Method
//                Picker("Sort by", selection: $sortOption) {
//                    Text("Expiration Date (Near to Far)").tag(SortOption.expirationDate)
//                    Text("Food Name (Alphabetical)").tag(SortOption.foodName)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding()
//                Menu("Sort", systemImage: "arrow.up.arrow.down") {
//                    Picker("Sort", selection: $sortOrder) {
//                        Text("Expiration Date (Near to Far)")
//                            .tag(SortDescriptor(\Food.expirationDate))
//                        Text("Food Name (Alphabetical)")
//                            .tag(SortDescriptor(\Food.name))
//                    }
//                    .pickerStyle(.inline)
//                }

                List{
                    ForEach(foodList) { food in
                        HStack {
                            if let imageData = food.image, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            } else {
                                Image(systemName: "photo.badge.plus")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                            
                            Text(food.name)
                            Spacer()
                            Text("\(food.expirationDaysLeft) days left")
                                .foregroundColor(food.expirationDaysLeft <= userSettings.first!.daysUntilNearExpiration ? .red : .primary)
                            Spacer()
                            Text("Quantity: \(food.quantity) \(food.unit)")
                                .font(.subheadline)
                            
                            NavigationLink(value: food) {
                            }
                        }
                    }
                    .onDelete(perform: deleteFoods)
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
        
    func deleteFoods(_ indexSet: IndexSet) {
        for index in indexSet {
            let food = foodList[index]
            modelContext.delete(food)
        }
    }

}
