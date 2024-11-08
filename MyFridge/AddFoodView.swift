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
    @State private var expirationDate: Date = Calendar.current.startOfDay(for: Date())
    @State private var quantity: Int = 1
    @State private var unit: String = ""
    @State private var detail: String = ""
    @State private var showCamera = false
    @State private var capturedImageData: Data?
    @Environment(\.modelContext) var modelContext
    @State private var selectedFoodName : String? = nil
    @State private var recognizedText: String? = nil
    @State private var originalImage: UIImage?
    @State private var nutrition: Nutrition?
    @State private var successed: Bool = false
//    @State private var cropRect: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100)

    
    func getNutrition() async throws -> Nutrition {
        let endpoint = "https://api.nal.usda.gov/fdc/v1/foods/search?api_key=Ygutx3ChhbAXlA0aB9xMGdPxZhcFBNKLeaMbYXOP&query=" + foodName + "&dataType=Foundation&pageSize=1&pageNumber=1"
        guard let url = URL(string: endpoint) else {
            throw NError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NError.invalidResponse
        }
        do {
            return try Nutrition.fromJSON(data)
        } catch {
            throw NError.invalidJSON
        }
    }
    
    
    func processImage(_ image: UIImage) {
            guard let cgImage = image.cgImage  else { return }
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let classifyRequest = VNClassifyImageRequest()
            let textRecognitionRequest = VNRecognizeTextRequest()
            do {
                try requestHandler.perform([classifyRequest, textRecognitionRequest])
                if let results = classifyRequest.results {
                    let filteredResults = results.filter { $0.confidence > 0.5 }.sorted { $0.confidence > $1.confidence }
                    selectedFoodName = filteredResults.map { "\($0.identifier) \($0.confidence)" }
                        .joined(separator: "\n")
//                    let filteredResults = results.filter { $0.confidence > 0.7 }.sorted { $0.confidence > $1.confidence }
//                    if let firstResult = filteredResults.first {
//                        selectedFoodName = firstResult.identifier
//                    }
                }
                if let results = textRecognitionRequest.results {
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
        NavigationStack {
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
                //    TODO: write guidance for taking photos for better image classification
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
                        // A NavigationLink is presenting a value of type “Food” but there is no matching navigationDestination declaration visible from the location of the link. The link cannot be activated.
                        // Note: Links search for destinations in any surrounding NavigationStack, then within the same column of a NavigationSplitView.
                        Task {
                            do {
                                nutrition = try await getNutrition()
                            } catch NError.invalidJSON {
                                print("invalid JSON")
                            } catch NError.invalidResponse {
                                print("invalid response")
                            } catch NError.invalidURL {
                                print("invalid url")
                            } catch {
                                print("unexpected error happened when fetching nutrition data")
                            }
                        }
//                        let newNutrition = Nutrition(energy: 1, water: 2, carbohydrate: 3, sugars: 4, protein: 5, fat: 6)
//                        let newFood = Food(name: foodName, expirationDate: expirationDate, quantity: quantity, unit: unit, image: capturedImageData, detail: detail, nutrition: newNutrition, ingredients: [])
                        let newFood = Food(name: foodName, expirationDate: expirationDate, quantity: quantity, unit: unit, image: capturedImageData, detail: detail, nutrition: nutrition ?? Nutrition())
                        modelContext.insert(newFood)
                        try? modelContext.save()
                        successed = true
//                        NavigationLink(destination: FoodListView(sort: SortDescriptor(\Food.expirationDate), searchText: "")) {}
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
            .alert(isPresented: $successed) {
                Alert(title: Text("Alert"), message: Text("New food saved!"))
            }
            .navigationTitle("Add Food")
        }
    }
}

//import SwiftUI
//import PhotosUI
//import AVFoundation
//import SwiftData
//
//struct AddFoodView: View {
//    @State private var foodName: String = ""
//    @State private var expirationDate: Date = Date()
//    @State private var quantity: Int = 1
//    @State private var unit: String = ""
//    @State private var detail: String = ""
//    @State private var showCamera = false
//    @State private var capturedImageData: Data?
//    @Environment(\.modelContext) var modelContext
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Food Information")) {
//                    TextField("Food Name", text: $foodName)
//                    DatePicker("Expiration Date", selection: $expirationDate, displayedComponents:.date)
//                    Stepper(value: $quantity, in: 1...100) {
//                        Text("Quantity: \(quantity)")
//                    }
//                    TextField("Unit:", text: $unit)
//                    TextField("More Detail", text: $detail)
//                }
//                Section(header: Text("Image")) {
//                    Button(action: {
//                        showCamera = true
//                    }) {
//                        Image(systemName: "camera")
//                            .resizable()
//                            .frame(width: 50, height: 50)
//                    }
//                }
//                Section {
//                    Button(action: {
//                        let newNutrition = Nutrition(energy: 1, water: 2, carbohydrate: 3, sugars: 4, protein: 5, fat: 6)
//                        //                        let newFood = Food(name: foodName, expirationDate: expirationDate, quantity: quantity, unit: unit, image: capturedImageData, detail: detail, nutrition: newNutrition, ingredients: [])
//                        let newFood = Food(name: foodName, expirationDate: expirationDate, quantity: quantity, unit: unit, image: capturedImageData, detail: detail, nutrition: newNutrition)
//                        modelContext.insert(newFood)
//                        try? modelContext.save()
//                    }) {
//                        Text("Save Food")
//                    }
//                }
//            }
//            .sheet(isPresented: $showCamera) {
//                CameraView(isShown: $showCamera) { image in
//                    // Store image as Data in Food
//                    if let imageData = image.jpegData(compressionQuality: 0.8) {
//                        capturedImageData = imageData
//                    }
//                }
//            }
//            .navigationTitle("Add Food")
//        }
//    }
//}
