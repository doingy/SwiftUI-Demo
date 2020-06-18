//
//  AppAction.swift
//  PokeMaster
//
//  Created by 杨冬青 on 2020/6/17.
//  Copyright © 2020 杨冬青. All rights reserved.
//

import Foundation

enum AppAction {
    case login(email: String, password: String)
    case accountBehaviorDone(result: Result<User, AppError>)
    
    case email(valid: Bool)
    
    case loadPokemons
    case loadPokemonsDone(result: Result<[PokemonViewModel], AppError>)
}
