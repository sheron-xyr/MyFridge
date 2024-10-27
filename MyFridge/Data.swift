//
//  data.swift
//  MyFridge
//
//  Created by 徐艺榕 on 2024/10/18.
//
//import Foundation
import SwiftUI
import SwiftData


@Model
class UserSettings {
    var showEnergy: Bool
    var showWater: Bool
    var showCarbohydrate: Bool
    var showSugars: Bool
    var showProtein: Bool
    var showFat: Bool
    var daysUntilNearExpiration: Int
    
    init(showEnergy: Bool = true, showWater: Bool = true, showCarbohydrate: Bool = true, showSugars: Bool = true, showProtein: Bool = true, showFat: Bool = true, daysUntilNearExpiration: Int = 3) {
        self.showEnergy = showEnergy
        self.showWater = showWater
        self.showCarbohydrate = showCarbohydrate
        self.showSugars = showSugars
        self.showProtein = showProtein
        self.showFat = showFat
        self.daysUntilNearExpiration = daysUntilNearExpiration
    }
}

@Model
class Nutrition {
    var energy: Double // kcal
    var water: Double // g
    var carbohydrate: Double // g
    var sugars: Double // g
    var protein: Double // g
    var fat: Double // g
    
    init(energy: Double = 0, water: Double = 0, carbohydrate: Double = 0, sugars: Double = 0, protein: Double = 0, fat: Double = 0) {
        self.energy = energy
        self.water = water
        self.carbohydrate = carbohydrate
        self.sugars = sugars
        self.protein = protein
        self.fat = fat
    }
}

// TODO: Circular reference between 3 models
//@Model
//class Ingredient {
//    @Relationship var food: Food
//    var quantity: Int
//    var unit: String
//    @Relationship var recipe: Recipe
//    
//    init(food: Food, quantity: Int = 1, unit: String = "piece", recipe: Recipe) {
//        self.food = food
//        self.quantity = quantity
//        self.unit = unit
//        self.recipe = recipe
//    }
//}


@Model
class Food {
//    let id = UUID()
    @Attribute(.unique) var name: String
    var expirationDate: Date
    var quantity: Int
    var unit: String
    var image: Data?
    var detail: String
    var nutrition: Nutrition
//    @Relationship(deleteRule: .cascade, inverse: \Ingredient.food) var ingredients: [Ingredient] = []
    var expirationDaysLeft: Int {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: currentDate, to: expirationDate)
        guard let days = components.day else {
            return 0
        }
        return days
    }
    
//    init(name: String, expirationDate: Date, quantity: Int, unit: String, image: Data? = nil, detail: String, nutrition: Nutrition, ingredients: [Ingredient]) {
    init(name: String = "", expirationDate: Date = Date(), quantity: Int = 1, unit: String = "", image: Data? = nil, detail: String = "", nutrition: Nutrition = Nutrition()) {
        self.name = name
        self.expirationDate = expirationDate
        self.quantity = quantity
        self.unit = unit
        self.image = image
        self.detail = detail
        self.nutrition = nutrition
//        self.ingredients = ingredients
    }
}

@Model
class Recipe {
    @Attribute(.unique) var name: String
    var image: Data?
    var steps: String
    var nutrition: Nutrition
    var isFavorite: Bool
    var ingredients: String
//    @Relationship(deleteRule: .cascade, inverse: \Ingredient.recipe) var ingredients: [Ingredient] = []
    
    init(name: String, image: Data? = nil, steps: String, nutrition: Nutrition, isFavorite: Bool = false, ingredients: String) {
        self.name = name
        self.image = image
        self.steps = steps
        self.nutrition = nutrition
        self.isFavorite = isFavorite
        self.ingredients = ingredients
    }
}

//var recipeList : [Recipe] = [
//    Recipe(
//        name: "Banana Smoothie",
//        imageName: "bananaSmoothieImage",
//        ingredients: ["2 ripe bananas", "1 cup milk", "1/4 cup yogurt", "1 tablespoon honey"],
//        steps: ["Peel and slice the bananas.", "Put the bananas, milk, yogurt, and honey in a blender.", "Blend until smooth."],
//        nutrition: Nutrition(
//            energy: 250,
//            water: 75.0,
//            carbohydrate: 40.0,
//            sugars: 30.0,
//            protein: 5.0,
//            fat: 5.0
//        ),
//        isFavorite: true
//    ),
//    Recipe(
//        name: "Banana Pancake",
//        imageName: "bananaPancakeImage",
//        ingredients: ["1 cup all-purpose flour", "2 tablespoons sugar", "1 teaspoon baking powder", "1/2 teaspoon salt", "1 egg", "1 cup milk", "2 tablespoons melted butter", "2 ripe bananas, mashed"],
//        steps: ["In a large bowl, combine the flour, sugar, baking powder, and salt.", "In a separate bowl, beat the egg. Add the milk and melted butter and stir to combine.", "Pour the wet ingredients into the dry ingredients and stir until just combined. Do not overmix.", "Fold in the mashed bananas.", "Heat a griddle or skillet over medium heat. Spray with cooking spray.", "Pour 1/4 cup of batter onto the griddle for each pancake.", "Cook until bubbles form on the surface of the pancake, then flip and cook until golden brown on both sides."],
//        nutrition: Nutrition(
//            energy: 300,
//            water: 40.0,
//            carbohydrate: 50.0,
//            sugars: 15.0,
//            protein: 8.0,
//            fat: 10.0
//        ),
//        isFavorite: false
//    ),
//    Recipe(
//        name: "Boiled Broccoli",
//        imageName: nil,
//        ingredients: ["1 bunch broccoli", "Salt to taste", "1 teaspoon olive oil"],
//        steps: ["Wash the broccoli and cut into florets.", "Bring a pot of water to a boil. Add salt and a teaspoon of olive oil.", "Put the broccoli florets into the boiling water and cook for about 5 minutes until tender but still crisp.", "Drain the broccoli and serve."],
//        nutrition: Nutrition(
//            energy: 50,
//            water: 85.0,
//            carbohydrate: 10.0,
//            sugars: 2.0,
//            protein: 4.0,
//            fat: 1.0
//        ),
//        isFavorite: false
//    ),
//    Recipe(
//        name: "Pan-Fried Steak",
//        imageName: "panFriedSteakImage",
//        ingredients: ["1 steak (your choice of cut)", "Salt and pepper to taste", "1 tablespoon olive oil", "1 clove garlic, minced"],
//        steps: ["Pat the steak dry with paper towels. Season both sides with salt and pepper.", "Heat a skillet over high heat. Add the olive oil.", "Once the oil is hot, add the steak. Cook for about 3-4 minutes per side for medium-rare, depending on the thickness of the steak.", "Remove the steak from the skillet and let it rest for a few minutes. In the same skillet, add the minced garlic and cook for a minute. Pour the garlic oil over the steak."],
//        nutrition: Nutrition(
//            energy: 350,
//            water: 50.0,
//            carbohydrate: 0.0,
//            sugars: 0.0,
//            protein: 30.0,
//            fat: 20.0
//        ),
//        isFavorite: false
//    ),
//    Recipe(
//        name: "Curry",
//        imageName: nil,
//        ingredients: ["1 onion, chopped", "2 cloves garlic, minced", "1 inch ginger, minced", "1 tablespoon oil", "1 tablespoon curry powder", "1 can coconut milk", "1 cup vegetables (such as carrots, potatoes, peas)", "Salt and pepper to taste"],
//        steps: ["Heat the oil in a pan. Add the chopped onion, minced garlic, and minced ginger. Sauté until fragrant.", "Add the curry powder and stir for a minute.", "Pour in the coconut milk and bring to a simmer.", "Add the vegetables and cook until tender. Season with salt and pepper."],
//        nutrition: Nutrition(
//            energy: 200,
//            water: 70.0,
//            carbohydrate: 20.0,
//            sugars: 5.0,
//            protein: 5.0,
//            fat: 10.0
//        ),
//        isFavorite: false
//    )
//]






//var foodList: [Food] = [
//    Food(
//        name: "Gala Apple",
//        expirationDate: Date().addingTimeInterval(86400 * 7),
//        quantity: 5,
//        imageName: "galaAppleImage",
//        detail: "5 pieces",
//        nutrition: Nutrition(
//            energy: 52,
//            water: 85.56,
//            carbohydrate: 14,
//            sugars: 10.39,
//            protein: 0.26,
//            fat: 0.17
//        ),
//        recipes: []
//    ),
//    Food(
//        name: "Banana",
//        expirationDate: Date().addingTimeInterval(86400 * 3),
//        quantity: 3,
//        imageName: "bananaImage",
//        detail: "3 pieces",
//        nutrition: Nutrition(
//            energy: 89,
//            water: 75,
//            carbohydrate: 22.84,
//            sugars: 12.23,
//            protein: 1.09,
//            fat: 0.33
//        ),
//        recipes: [recipeList[0], recipeList[1]]
//    ),
//    Food(
//        name: "Beef (Steak)",
//        expirationDate: Date().addingTimeInterval(86400 * 2),
//        quantity: 1,
//        imageName: "beefSteakImage",
//        detail: "1 piece",
//        nutrition: Nutrition(
//            energy: 250,
//            water: 50.0,
//            carbohydrate: 0.0,
//            sugars: 0.0,
//            protein: 30.0,
//            fat: 20.0
//        ),
//        recipes: [recipeList[3]]
//    ),
//    Food(
//        name: "Milk",
//        expirationDate: Date().addingTimeInterval(86400 * 10), // 10 days from now
//        quantity: 1,
//        imageName: "milkImage",
//        detail: "1 gallon per container",
//        nutrition: Nutrition(
//            energy: 60,
//            water: 87,
//            carbohydrate: 5,
//            sugars: 5,
//            protein: 3,
//            fat: 3
//        ),
//        recipes: [recipeList[0]]
//    ),
//    Food(
//        name: "Broccoli",
//        expirationDate: Date().addingTimeInterval(86400 * 7),
//        quantity: 1,
//        imageName: "broccoliImage",
//        detail: "1 bunch",
//        nutrition: Nutrition(
//            energy: 34,
//            water: 89.3,
//            carbohydrate: 6.64,
//            sugars: 1.7,
//            protein: 2.82,
//            fat: 0.37
//        ),
//        recipes: [recipeList[2]]
//    )
//]
