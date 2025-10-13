//
//  ContentView.swift
//  CounterApp
//
//  Created by Zaki Menzhanov on 07.10.2025.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<CounterFeature>

    var body: some View {
        Form {
            Section {
                Text("\(store.count)")
                Button("Decrement") { store.send(.decrementButtonTapped) }
                Button("Increment") { store.send(.incrementButtonTapped) }
            }

            Section {
                Button(
                    store.isTimerRunning ?
                    "Stop timer" :
                        "Start timer"
                ) { store.send(.toggleButtonTimerTapped)}
                Button("Number fact") { store.send(.numberFactButtonTapped) }
            }

            if store.isLoading {
                ProgressView()
            } else if let fact = store.numberFact {
                Text(fact)
            }
        }
    }
}
