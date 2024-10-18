//
//  AddFoodView.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/18.
//

import SwiftUI
import PhotosUI
import AVFoundation

struct AddFoodView: View {
    @State private var foodName: String = ""
    @State private var expirationDate: Date = Date()
    @State private var quantity: Int = 1
    @State private var detail: String = ""
    @State private var showCamera = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food Information")) {
                    TextField("Food Name", text: $foodName)
                    DatePicker("Expiration Date", selection: $expirationDate, displayedComponents:.date)
                    Stepper(value: $quantity, in: 1...100) {
                        Text("Quantity: \(quantity)")
                    }
                    TextField("More Detail", text: $detail)
                }
                Section(header: Text("Image")) {
                    Button(action: {
                        showCamera = true
                    }) {
                        Image(systemName: "camera")
                          .resizable()
                          .frame(width: 50, height: 50)
                    }
                }
                Section {
                    Button(action: {
                        let newNutrition = Nutrition(energy: 0, water: 0, carbohydrate: 0, sugars: 0, protein: 0, fat: 0)
                        let newFood = Food(name: foodName, expirationDate: expirationDate, quantity: quantity, imageName: nil, detail: detail, nutrition: newNutrition, recipes: [])
                        foodList.append(newFood)
                    }) {
                        Text("Save Food")
                    }
                }
            }
          .sheet(isPresented: $showCamera) {
                CameraView(isShown: $showCamera) { image in
                    // Save image to Photos library
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            }
          .navigationTitle("Add Food")
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    let onImageCaptured: (UIImage) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImageCaptured(image)
            }
            parent.isShown = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShown = false
        }
    }
}
