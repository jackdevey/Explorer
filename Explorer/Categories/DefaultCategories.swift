//
//  DefaultCategories.swift
//  Explorer
//
//  Created by Jack Devey on 31/07/2023.
//

import Foundation

var defaultCategories: [Category] = [
    // Food & Drink
    Category(
        icon: "fork.knife",
        name: "Food & Drink",
        searchTerms: [
            "Food & Drink",
            "Food places"
        ],
        color: .orange,
        image: .foodDrinkBackground
    ),
    // Entertainment
    Category(
        icon: "star.fill",
        name: "Entertainment",
        searchTerms: [
            "Entertainment"
        ],
        color: .red,
        image: .entertainmentBackground
    ),
    // Fitness
    Category(
        icon: "figure.run",
        name: "Exercise Activities",
        searchTerms: [
            "Exercise Activities",
            "Outdoor Activities",
            "Fitness"
        ],
        color: .green,
        image: .fitnessBackground
    ),
]
