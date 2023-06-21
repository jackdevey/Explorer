//
//  MapView.swift
//  Explorer
//
//  Created by Jack Devey on 19/06/2023.
//

import Foundation

struct ListType: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let name: String
    let searchTerm: String
}
