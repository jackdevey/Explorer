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
            "Resturants",
            "Food places"
        ],
        color: .orange),
    // Entertainment
    Category(
        icon: "star.fill",
        name: "Entertainment",
        searchTerms: [
            "Entertainment",
            "Activities",
        ],
        color: .red
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
        color: .green
    ),
]
