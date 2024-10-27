//
//  FoodDetailView.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/18.
//

import SwiftUI
import SwiftData

struct FoodDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var food : Food
    @Query var userSettings: [UserSettings]
//    @State private var pfood : Food = foodList[0]
    @State private var isEditing = false
//    @State private var newQuantity: Int?
//    @State private var newExpirationDate: Date
    
//    init(food: Food, pfood: Food = foodList[0], isEditing: Bool = false, newQuantity: Int? = nil, newExpirationDate: Date = Date()) {
//        self.food = food
//        self.pfood = food
//        self.isEditing = isEditing
//        self.newQuantity = newQuantity
//        self.newExpirationDate = newExpirationDate
//    }

    var body: some View {
        let setting : UserSettings = userSettings.first!
        VStack(alignment:.leading) {
//            Text(pfood.name)
//               .font(.title)

            if let imageData = food.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 300, height: 300)
            } else {
                Image(systemName: "photo.badge.plus")
                    .resizable()
                    .frame(width: 300, height: 300)
            }
            
            if isEditing {
                VStack(alignment:.leading) {
                    HStack{
                        Text("Quantity: ")
                        TextField("Quantity: ", value: $food.quantity, format:.number)
                           .keyboardType(.numberPad)
                        Text(" \(food.unit)")
                    }
                    
                    DatePicker("Expiration Date: ", selection: $food.expirationDate, displayedComponents:.date)
                }
            } else {
                VStack(alignment:.leading) {
                    Text("Quantity: \(food.quantity) \(food.unit)")
                    Text("Expiration Date: \(food.expirationDate.formatted(date: .abbreviated, time: .omitted)), \(food.expirationDaysLeft) days left")
                        .foregroundColor(food.expirationDaysLeft <= userSettings.first!.daysUntilNearExpiration ? .red : .primary)

                }
            }
            
            if setting.showEnergy {
                Text("Energy: \(String(format: "%.1f", food.nutrition.energy)) kcal")
            }
            if setting.showWater {
                Text("Water: \(String(format: "%.1f", food.nutrition.water)) g")
            }
            if setting.showCarbohydrate {
                Text("Carbohydrate: \(String(format: "%.1f", food.nutrition.carbohydrate)) g")
            }
            if setting.showSugars {
                Text("Sugars: \(String(format: "%.1f", food.nutrition.sugars)) g")
            }
            if setting.showProtein {
                Text("Protein: \(String(format: "%.1f", food.nutrition.protein)) g")
            }
            if setting.showFat {
                Text("Fat: \(String(format: "%.1f", food.nutrition.fat)) g")
            }
            
        // TODO: why hidden shows error: Argument passed to call that takes no arguments
//            Text("Energy: \(food.nutrition.energy) kcal")
//                .hidden(!setting.showEnergy)

//            if !food.recipes.isEmpty {
//                Text("Recipes:")
//                ForEach(food.recipes) { recipe in
//                    Text(recipe.name)
//                }
//            }


            Button(action: {
                if isEditing {
                    try? modelContext.save()
                    isEditing = false
                } else {
                    isEditing = true
                }
            }) {
                if isEditing {
                    Text("Confirm")
                } else {
                    Text("Edit")
                }
            }
        }
       .padding()
       .navigationTitle(food.name)
    }
}
//
//struct FoodDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodDetailView(food: foodList[0])
//    }
//}
