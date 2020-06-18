//
//  PokemonRootView.swift
//  PokeMaster
//
//  Created by 杨冬青 on 2020/6/17.
//  Copyright © 2020 杨冬青. All rights reserved.
//

import SwiftUI

struct PokemonRootView: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        NavigationView {
            if store.appState.pokemonList.pokemons == nil {
                Text("Loading...").onAppear() {
                    self.store.dispatch(.loadPokemons)
                }
            } else {
                PokemonList().navigationBarTitle("宝可梦列表")
            }
        }
    }
}

struct PokemonRootView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonRootView()
    }
}
