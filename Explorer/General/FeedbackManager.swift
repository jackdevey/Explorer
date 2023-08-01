//
//  FeedbackManager.swift
//  Explorer
//
//  Created by Jack Devey on 01/08/2023.
//

import SwiftUI

class FeedbackManager: ObservableObject {
    
    private let softGenerator = UIImpactFeedbackGenerator(style: .soft)
    private let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let rigidGenerator = UIImpactFeedbackGenerator(style: .rigid)
    
    func soft() {
        softGenerator.impactOccurred()
    }
    
    func medium() {
        mediumGenerator.impactOccurred()
    }
    
    func rigid() {
        rigidGenerator.impactOccurred()
    }
    
}
