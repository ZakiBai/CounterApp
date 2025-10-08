//
//  CounterFeature.swift
//  CounterApp
//
//  Created by Zaki Menzhanov on 07.10.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CounterFeature {

    @Dependency(\.catFact) var catFact

    @ObservableState
    struct State: Equatable {
        var count = 0
        var numberFact: String?
    }

    enum Action: Equatable {
        case decrementButtonTapped
        case incrementButtonTapped
        case numberFactButtonTapped
        case numberFactButtonResponse(String  )
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
                    let fact = try await catFact.fetch()
                    await send(.numberFactButtonResponse(fact))
                }

            case let .numberFactButtonResponse(fact):
                state.numberFact = fact
                return .none
            }
        }
    }
}

struct CatFactClient {
    var fetch: () async throws -> String
}

extension CatFactClient: DependencyKey {
    static var liveValue: CatFactClient {
        Self(
            fetch: {
                let (data, _) = try await URLSession.shared.data(
                    from: URL(string: "https://catfact.ninja/fact")!
                )
                let factModel = try JSONDecoder().decode(FactModel.self, from: data)
                return factModel.fact
            }
        )
    }
}

extension DependencyValues {
    var catFact: CatFactClient {
        get { self[CatFactClient.self] }
        set { self[CatFactClient.self] = newValue }
    }
}
