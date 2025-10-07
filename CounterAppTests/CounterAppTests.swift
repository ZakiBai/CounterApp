//
//  CounterAppTests.swift
//  CounterAppTests
//
//  Created by Zaki Menzhanov on 07.10.2025.
//

import Testing
import ComposableArchitecture
import XCTest

@testable import CounterApp

@MainActor
final class CounterAppTests: XCTestCase {

    func test_basics() async {
        let store = TestStore(
            initialState: CounterFeature.State()
        ) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
        
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }
    
    func test_factButtonTapped() async {
        let store = TestStore(
            initialState: CounterFeature.State()
        ) {
            CounterFeature()
        } withDependencies: {
            $0.catFact.fetch = { "Hi Kitty" }
        }
        
        await store.send(.numberFactButtonTapped)
        await store.receive(.numberFactButtonResponse("Hi Kitty")) {
            $0.numberFact = "Hi Kitty"
        }
    }

}
