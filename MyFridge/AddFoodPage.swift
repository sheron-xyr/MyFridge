//
//  AddFoodPage.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/12.
//

import SwiftUI

struct AddFoodPage: View {
    @Binding var selectedTab: Tab
    @State var capturedImage: Image?
    @State var recognizedFoodName: String = ""
    @State var expirationDate: String = ""
    @State var quantity: Int = 1

    var body: some View {
        VStack {
            if let image = capturedImage {
                image
                  .resizable()
                  .aspectRatio(contentMode:.fit)
            }
            Text(recognizedFoodName)
            Text(expirationDate)
            Text("Quantity: \(quantity)")
            HStack {
                Button(action: {
                    selectedTab = .foodList
                }) {
                    Text("Cancel")
                }
                Button(action: {
                    // Add food and go back to food list page
                    let newFood = Food(name: recognizedFoodName, expirationDate: expirationDate, quantity: quantity, isNearExpiration: false, expirationDaysLeft: 0, imageName: "apple", nutrition: nil, recipes: [])
                    foodData.append(newFood)
                    selectedTab = .foodList
                }) {
                    Text("Add")
                }
            }
        }
    }
}

//#Preview {
//    AddFoodPage()
//}
