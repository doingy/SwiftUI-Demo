//
//  AppCommand.swift
//  PokeMaster
//
//  Created by 杨冬青 on 2020/6/17.
//  Copyright © 2020 杨冬青. All rights reserved.
//

import Foundation
import Combine

protocol AppCommand {
    func execute(in store: Store)
}

// MARK: - LoginAppCommand

struct LoginAppCommand: AppCommand {
    let email: String
    let password: String
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoginRequest(email: email, password: password).publisher.sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                store.dispatch(.accountBehaviorDone(result: .failure(error)))
            }
            
            token.unseal()
        }) { user in
            store.dispatch(.accountBehaviorDone(result: .success(user)))
        }
        .seal(in: token)
    }
}

// MARK: - LoadPokemonsCommand

struct LoadPokemonsCommand: AppCommand {
    func execute(in store: Store) {
        let token = SubscriptionToken()
        
        LoadPokemonRequest.all
            .sink(receiveCompletion: { complete in
                if case .failure(let error) = complete {
                    store.dispatch(.loadPokemonsDone(result: .failure(error)))
                }
                token.unseal()
            }, receiveValue: { value in
                store.dispatch(.loadPokemonsDone(result: .success(value)))
            })
            .seal(in: token)
    }
}

// MARK: -

class SubscriptionToken {
    var cancellable: AnyCancellable?
    
    func unseal() {
        cancellable = nil
    }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}
