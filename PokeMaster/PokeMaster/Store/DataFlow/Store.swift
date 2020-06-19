//
//  Store.swift
//  PokeMaster
//
//  Created by 杨冬青 on 2020/6/17.
//  Copyright © 2020 杨冬青. All rights reserved.
//

import Foundation
import Combine

class Store: ObservableObject {
    @Published var appState = AppState()
    
    var disposeBag: [AnyCancellable] = []
    
    init() {
        setupObservers()
    }
    
    func setupObservers() {
        appState.settings.checker.isEmailValid.sink { isValid in
            self.dispatch(.email(valid: isValid))
        }
        .store(in: &disposeBag)
    }
    
    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[Action]:\(action)")
        #endif
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        
        if let command = result.1 {
            #if DEBUG
            print("[Command]:\(command)")
            #endif
            command.execute(in: self)
        }
    }
    
    static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?
        
        switch action {
        case .login(let email, let password):
            guard !appState.settings.loginRequesting else {
                break
            }
            appState.settings.loginRequesting = true
            
            appCommand = LoginAppCommand(email: email, password: password)
        
        case .accountBehaviorDone(let result):
            appState.settings.loginRequesting = false
            switch result {
            case .success(let user):
                appState.settings.loginUser = user
                
            case .failure(let error):
                appState.settings.loginError = error
            }
            
        case .logout:
            appState.settings.loginUser = nil
            
        case .email(let valid):
            appState.settings.isEmailValid = valid
            
        case .toggleListSelection(let index):
            let expanding = appState.pokemonList.selectionsState.expandingIndex
            if expanding == index {
                appState.pokemonList.selectionsState.expandingIndex = nil
                appState.pokemonList.selectionsState.panelPresented = false
            } else {
                appState.pokemonList.selectionsState.expandingIndex = index
                appState.pokemonList.selectionsState.panelIndex = index
            }
            
        case .togglePanelPresenting(let presenting):
            appState.pokemonList.selectionsState.panelPresented = presenting
            
        case .loadPokemons:
            if appState.pokemonList.loadingPokemons {
                break
            }
            
            appState.pokemonList.loadingPokemons = true
            appCommand = LoadPokemonsCommand()
            
        case .loadPokemonsDone(let result):
            switch result {
            case .success(let models):
                appState.pokemonList.pokemons = Dictionary(uniqueKeysWithValues: models.map { ($0.id, $0) })
                
            case .failure(let error):
                print(error)
            }
            
        case .closeSafariView:
            appState.pokemonList.isSFViewActive = false
            
        case .loadAbilities(let pokemon):
            appCommand = LoadAbilitiesCommand(pokemon: pokemon)
            
        case .loadAbilitiesDone(let result):
            switch result {
            case .success(let loadedAbilities):
                var abilities = appState.pokemonList.abilities ?? [:]
                for ability in loadedAbilities {
                    abilities[ability.id] = ability
                }
                appState.pokemonList.abilities = abilities
                
            case .failure(let error):
                print(error)
            }
            
        case .clearCache:
            appState.pokemonList.pokemons = nil
            appState.pokemonList.abilities = nil
        }
        
        return (appState, appCommand)
    }
}
