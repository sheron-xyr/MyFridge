//
//  AddFoodView.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/18.
//

import SwiftUI
import PhotosUI
import AVFoundation
import SwiftData
import Vision


struct AddFoodView: View {
    @State private var foodName: String = ""
    @State private var expirationDate: Date = Date()
    @State private var quantity: Int = 1
    @State private var unit: String = ""
    @State private var detail: String = ""
    @State private var showCamera = false
    @State private var capturedImageData: Data? = nil
    @Environment(\.modelContext) var modelContext
    @State private var selectedFoodName : String? = nil
    @State private var recognizedText: String? = nil
    @State private var originalImage: UIImage?
//    @State private var cropRect: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100)

//    
    func processImage(_ image: UIImage) {
            guard let cgImage = image.cgImage  else { return }
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let classifyRequest = VNClassifyImageRequest()
            let textRecognitionRequest = VNRecognizeTextRequest()
            do {
                try requestHandler.perform([classifyRequest, textRecognitionRequest])
                if let results = classifyRequest.results as? [VNClassificationObservation] {
                    let filteredResults = results.filter { $0.confidence > 0.7 }.sorted { $0.confidence > $1.confidence }
                    if let firstResult = filteredResults.first {
                        selectedFoodName = firstResult.identifier
                    }
                }
                if let results = textRecognitionRequest.results as? [VNRecognizedTextObservation] {
                    if let topResult = results.first?.topCandidates(1).first {
                        recognizedText = topResult.string
                    }
                }
                capturedImageData = image.pngData()
            } catch {
                print("Error processing image: \(error)")
            }
        }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food Information")) {
                    TextField("Food Name", text: $foodName)
                    DatePicker("Expiration Date", selection: $expirationDate, displayedComponents:.date)
                    Stepper(value: $quantity, in: 1...100) {
                        Text("Quantity: \(quantity)")
                    }
                    TextField("Unit:", text: $unit)
                    TextField("More Detail", text: $detail)
                }
                // TODO: write guidance for taking photos for better image classification
                Section(header: Text("Image"), footer: Text("Guidance for taking photos")) {
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
                    if selectedFoodName != nil || recognizedText != nil {
                        VStack {
                            if selectedFoodName != nil {
                                Text("Recognized Food Name: \(selectedFoodName!)")
                                Button("Apply to Food Name"){
                                    foodName = "\(selectedFoodName!)"
                                }
                            }
                            if recognizedText != nil {
                                // TODO: how to allow edit?
                                Text("Recognized Text: \(recognizedText!)")
                                Button("Append to details"){
                                    detail += "\n\(recognizedText!)"
                                }
                            }
                        }
                    }
                }
                Section {
                    Button(action: {
                        // TODO: navigate to FoodList page after saving
                        let newNutrition = Nutrition(energy: 1, water: 2, carbohydrate: 3, sugars: 4, protein: 5, fat: 6)
//                        let newFood = Food(name: foodName, expirationDate: expirationDate, quantity: quantity, unit: unit, image: capturedImageData, detail: detail, nutrition: newNutrition, ingredients: [])
                        let newFood = Food(name: foodName, expirationDate: expirationDate, quantity: quantity, unit: unit, image: capturedImageData, detail: detail, nutrition: newNutrition)
                        modelContext.insert(newFood)
                        try? modelContext.save()
                        NavigationLink(destination: FoodListView(sort: SortDescriptor(\Food.expirationDate), searchText: "")) {}
                    }) {
                        Text("Save Food")
                    }
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraView(isShown: $showCamera) { image in
//                    originalImage = image
//                    processImage(image)
                    // Store image as Data in Food
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        capturedImageData = imageData
                        originalImage = image
                        processImage(image)
                    }
                }
            }
            .navigationTitle("Add Food")
        }
    }
}

