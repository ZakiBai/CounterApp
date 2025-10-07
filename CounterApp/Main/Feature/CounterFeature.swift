//
//  CounterFeature.swift
//  CounterApp
//
//  Created by Zaki Menzhanov on 07.10.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct CounterFeature {
    
    @ObservableState
    struct State: Equatable {
        var count = 0
        var numberFact: String?
    }
    
    enum Action: Equatable {
        case decrementButtonTapped
        case incrementButtonTapped
        case numberFactButtonTapped
        case numberFactButtonResponse(String)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                return .none
                
            case .incrementButtonTapped:
                state.count += 1
                return .none
                
            case .numberFactButtonTapped:
                return .run { send in
                    let (data, _) = try await URLSession.shared.data(from: URL(string: "https://catfact.ninja/fact")!)
                    let factModel = try JSONDecoder().decode(FactModel.self, from: data)
                    await send(.numberFactButtonResponse(factModel.fact))
                }
                
            case let .numberFactButtonResponse(fact):
                state.numberFact = fact
                return .none
            }
        }
    }
}
