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

enum NError: Error {
    case invalidURL
    case invalidResponse
    case invalidJSON
}


@Model
class Nutrition {
    var energy: Double // kcal
    var water: Double // g
    var carbohydrate: Double // g
    var sugars: Double // g
    var protein: Double // g
    var fat: Double // g
    
    init(energy: Double = -1, water: Double = -1, carbohydrate: Double = -1, sugars: Double = -1, protein: Double = -1, fat: Double = -1) {
        self.energy = energy
        self.water = water
        self.carbohydrate = carbohydrate
        self.sugars = sugars
        self.protein = protein
        self.fat = fat
    }
    
    static func fromJSON(_ data: Data) throws -> Nutrition {
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NError.invalidJSON
        }
        
        let foodNutrients = (json["foods"] as? [[String: Any]])?.first?["foodNutrients"] as? [[String: Any]] ?? []
        
        var energy: Double = -1
        var water: Double = -1
        var carbohydrate: Double = -1
        var sugars: Double = -1
        var protein: Double = -1
        var fat: Double = -1
        
        for nutrient in foodNutrients {
            if let nutrientId = nutrient["nutrientId"] as? Int,
               let value = nutrient["value"] as? Double {
                switch nutrientId {
                case 2047:
                    energy = value
                case 1051:
                    water = value
                case 1005:
                    carbohydrate = value
                case 2000:
                    sugars = value
                case 1003:
                    protein = value
                case 1004:
                    fat = value
                default:
                    continue
                }
            }
        }
        
        return Nutrition(energy: energy, water: water, carbohydrate: carbohydrate, sugars: sugars, protein: protein, fat: fat)
    }
}

@Model
class Food {
    @Attribute(.unique) var name: String
    var expirationDate: Date
    var quantity: Int
    var unit: String
    var image: Data?
    var detail: String
    var nutrition: Nutrition
    var expirationDaysLeft: Int {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: currentDate, to: expirationDate)
        guard let days = components.day else {
            return 0
        }
        return days
    }
    
    init(name: String = "", expirationDate: Date = Date(), quantity: Int = 1, unit: String = "", image: Data? = nil, detail: String = "", nutrition: Nutrition = Nutrition()) {
        self.name = name
        self.expirationDate = expirationDate
        self.quantity = quantity
        self.unit = unit
        self.image = image
        self.detail = detail
        self.nutrition = nutrition
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
    
    init(name: String, image: Data? = nil, steps: String, nutrition: Nutrition = Nutrition(), isFavorite: Bool = false, ingredients: String) {
        self.name = name
        self.image = image
        self.steps = steps
        self.nutrition = nutrition
        self.isFavorite = isFavorite
        self.ingredients = ingredients
    }
}
