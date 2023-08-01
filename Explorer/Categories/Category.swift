//
//  MapView.swift
//  Explorer
//
//  Created by Jack Devey on 19/06/2023.
//

import Foundation
import SwiftUI

struct Category: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let name: String
    let searchTerms: [String]
    let color: Color
    let image: ImageResource
    
    var searchTerm: String {
        searchTerms.randomElement()!
    }
}
