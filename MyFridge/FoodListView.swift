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
                List {
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
