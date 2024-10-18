//
//  FoodDetailView.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/18.
//

import SwiftUI

struct FoodDetailView: View {
    var food : Food
    @State private var pfood : Food = foodList[0]
    @State private var isEditing = false
    @State private var newQuantity: Int?
    @State private var newExpirationDate: Date
    
    init(food: Food, pfood: Food = foodList[0], isEditing: Bool = false, newQuantity: Int? = nil, newExpirationDate: Date = Date()) {
        self.food = food
        self.pfood = food
        self.isEditing = isEditing
        self.newQuantity = newQuantity
        self.newExpirationDate = newExpirationDate
    }

    var body: some View {
        VStack(alignment:.leading) {
//            Text(pfood.name)
//               .font(.title)

            if let imageName = pfood.imageName {
                Image(imageName)
                   .resizable()
                   .frame(width: 150, height: 150)
            } else {
                Image(systemName: "photo.badge.plus")
                   .resizable()
                   .frame(width: 150, height: 150)
            }
            
            Text("Expiration Date: \(pfood.expirationDate)")
            if pfood.isNearExpiration {
                Text("This food is near expiration.")
                   .foregroundColor(.red)
            } else {
                Text("Days left until expiration: \(pfood.expirationDaysLeft)")
            }

            if settings.showEnergy {
                Text("Energy: \(pfood.nutrition.energy) kcal")
            }
            if settings.showWater {
                Text("Water: \(pfood.nutrition.water) g")
            }
            if settings.showCarbohydrate {
                Text("Carbohydrate: \(pfood.nutrition.carbohydrate) g")
            }
            if settings.showSugars {
                Text("Sugars: \(pfood.nutrition.sugars) g")
            }
            if settings.showProtein {
                Text("Protein: \(pfood.nutrition.protein) g")
            }
            if settings.showFat {
                Text("Fat: \(pfood.nutrition.fat) g")
            }

            if !pfood.recipes.isEmpty {
                Text("Recipes:")
                ForEach(pfood.recipes) { recipe in
                    Text(recipe.name)
                }
            }

            if isEditing {
                HStack {
                    TextField("Quantity", value: $newQuantity, format:.number)
                       .keyboardType(.numberPad)
                    DatePicker("Expiration Date", selection: $newExpirationDate, displayedComponents:.date)
                }
            } else {
                HStack {
                    Text("Quantity: \(pfood.quantity) pieces")
                    Text("Expiration Date: \(pfood.expirationDate)")
                }
            }

            Button(action: {
                if isEditing {
                    if let quantity = newQuantity {
                        pfood.quantity = quantity
                        pfood.expirationDate = newExpirationDate
                        if let index = foodList.firstIndex(where: { $0.id == pfood.id }) {
                            foodList[index] = pfood
                        }
                    }
                    isEditing = false
                } else {
                    isEditing = true
                    newQuantity = pfood.quantity
                    newExpirationDate = pfood.expirationDate
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
