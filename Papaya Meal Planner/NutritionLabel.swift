//
//  NutritionLabel.swift
//  Papaya Meal Planner
//
//  Created by Norton Gumbo on 12/17/16.
//  Copyright © 2016 Papaya LC. All rights reserved.
//

import Foundation
import Marshal

class NutritionLabel: Unmarshaling {
    let energyKcal: Int
    let totalFat: Int
    let totalFatPercentage: Int
    let saturatedFat: Int
    let monounsaturatedFat: Int
    let polyunsaturatedFat: Int
    let cholesterol: Int
    let sodium: Int
    let totalCarbohydrate: Int
    let totalCarbohydratePercentage: Int
    let dietaryFiber: Int
    let sugars: Int
    let protein: Int
    let proteinPercentage: Int
    let vitaminA: Int
    let vitaminC: Int
    let calcium: Int
    let iron: Int
    let potassium: Int
    
    required init(object: MarshaledObject) throws {
        energyKcal = try object.value(for: "energy_kcal")
        totalFat = try object.value(for: "total_fat")
        totalFatPercentage = try object.value(for: "total_fat_percentage")
        saturatedFat = try object.value(for: "saturated_fat")
        monounsaturatedFat = try object.value(for: "monounsaturated_fat")
        polyunsaturatedFat = try object.value(for: "polyunsaturated_fat")
        cholesterol = try object.value(for: "cholesterol")
        sodium = try object.value(for: "sodium")
        totalCarbohydrate = try object.value(for: "total_carbohydrate")
        totalCarbohydratePercentage = try object.value(for: "total_carbohydrate_percentage")
        dietaryFiber = try object.value(for: "dietary_fiber")
        sugars = try object.value(for: "sugars")
        protein = try object.value(for: "protein")
        proteinPercentage = try object.value(for: "protein_percentage")
        vitaminA = try object.value(for: "vitamin_a")
        vitaminC = try object.value(for: "vitamin_c")
        calcium = try object.value(for: "calcium")
        iron = try object.value(for: "iron")
        potassium = try object.value(for: "potassium")
        
    }
    
    init() {
        energyKcal = 0
        totalFat = 0
        totalFatPercentage = 0
        saturatedFat = 0
        monounsaturatedFat = 0
        polyunsaturatedFat = 0
        cholesterol = 0
        sodium = 0
        totalCarbohydrate = 0
        totalCarbohydratePercentage = 0
        dietaryFiber = 0
        sugars = 0
        protein = 0
        proteinPercentage = 0
        vitaminA = 0
        vitaminC = 0
        calcium = 0
        iron = 0
        potassium = 0
    }
}
