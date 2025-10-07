//
//  CounterAppApp.swift
//  CounterApp
//
//  Created by Zaki Menzhanov on 07.10.2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct CounterAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: CounterFeature.State(), reducer: {
                CounterFeature()
            }))
        }
    }
}
