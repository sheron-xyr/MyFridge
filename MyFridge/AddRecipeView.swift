//
//  AddRecipeView.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/11/18.
//


import SwiftUI
import PhotosUI
import AVFoundation
import SwiftData
import Vision


struct AddRecipeView: View {
    @State private var recipeName: String = ""
    @State private var steps: String = ""
    @State private var ingredients: String = ""
    @State private var isFavorite: Bool = false
    @State private var showCamera = false
    @State private var capturedImageData: Data?
    @Environment(\.modelContext) var modelContext
    @State private var successed: Bool = false
    
    
    var body: some View {
        //        NavigationStack {
        Form {
            Section(header: Text("Recipe Information")) {
                TextField("Recipe Name: ", text: $recipeName)
                TextField("Steps: ", text: $steps)
                TextField("Ingredients: ", text: $ingredients)
                Toggle("Favorite", isOn: $isFavorite)
            }
            //
            Section(header: Text("Image")) {
                Button(action: {
                    showCamera = true
                }) {
                    Image(systemName: "camera")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                if let data = capturedImageData {
                    Image(uiImage: UIImage(data: data)!)
                        .resizable()
                        .aspectRatio(contentMode:.fit)
                }
            }
            Section {
                Button(action: {
                    // TODO: navigate to Recipe List page after saving
                    Task {
                        //                        let newNutrition = Nutrition(energy: 1, water: 2, carbohydrate: 3, sugars: 4, protein: 5, fat: 6)
                        //                        let newFood = Food(name: foodName, expirationDate: expirationDate, quantity: quantity, unit: unit, image: capturedImageData, detail: detail, nutrition: newNutrition, ingredients: [])
                       
                    }
                    let newRecipe = Recipe(name: recipeName, image: capturedImageData, steps: steps, isFavorite: isFavorite, ingredients: ingredients)
                    modelContext.insert(newRecipe)
                    try? modelContext.save()
                    successed = true
                }) {
                    Text("Save Recipe")
                }
            }
        }
        .sheet(isPresented: $showCamera) {
            CameraView(isShown: $showCamera) { image in
                //                    originalImage = image
                //                    processImage(image)
                // Store image as Data in Recipe
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    capturedImageData = imageData
                }
            }
        }
        .alert(isPresented: $successed) {
            Alert(title: Text("Alert"), message: Text("New recipe saved!"))
        }
        .navigationTitle("Add Recipe")
        //        }
    }
}
