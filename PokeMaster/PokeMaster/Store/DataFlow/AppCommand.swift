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
