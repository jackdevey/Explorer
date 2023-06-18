//
//  ExplorerApp.swift
//  Explorer
//
//  Created by Jack Devey on 18/06/2023.
//

import SwiftUI
import SwiftData

@main
struct ExplorerApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
