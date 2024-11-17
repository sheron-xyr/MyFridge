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
    @State private var isEditing = false
    
    var body: some View {
        let setting : UserSettings = userSettings.first!
        VStack(alignment:.leading) {
            
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
                if food.nutrition.energy != -1 {
                    Text("Energy: \(String(format: "%.1f", food.nutrition.energy)) kcal")
                }
                else {
                    Text("Energy: unknown")
                }
            }
            if setting.showWater {
                if food.nutrition.water != -1 {
                    Text("Water: \(String(format: "%.1f", food.nutrition.water)) g")
                }
                else {
                    Text("Water: unknown")
                }
            }
            if setting.showCarbohydrate {
                if food.nutrition.carbohydrate != -1 {
                    Text("Carbohydrate: \(String(format: "%.1f", food.nutrition.carbohydrate)) g")
                }
                else {
                    Text("Carbohydrate: unknown")
                }
            }
            if setting.showSugars {
                if food.nutrition.sugars != -1 {
                    Text("Sugars: \(String(format: "%.1f", food.nutrition.sugars)) g")
                }
                else {
                    Text("Sugars: unknown")
                }
            }
            if setting.showProtein {
                if food.nutrition.protein != -1 {
                    Text("Protein: \(String(format: "%.1f", food.nutrition.protein)) g")
                }
                else {
                    Text("Protein: unknown")
                }
                
            }
            if setting.showFat {
                if food.nutrition.fat != -1 {
                    Text("Fat: \(String(format: "%.1f", food.nutrition.fat)) g")
                }
                else {
                    Text("Fat: unknown")
                }
            }
            
            Text("Other details: \(food.detail)")
            
            
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
