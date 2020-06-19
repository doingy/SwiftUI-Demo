//
//  PokemonList.swift
//  PokeMaster
//
//  Created by 杨冬青 on 2020/6/11.
//  Copyright © 2020 杨冬青. All rights reserved.
//

import SwiftUI

struct PokemonList: View {

    @EnvironmentObject var store: Store
    
    var pokemonList: AppState.PokemonList {
        store.appState.pokemonList
    }
    
    var body: some View {
        ScrollView {
            TextField("搜索", text: $store.appState.pokemonList.searchText.animation(nil))
                .frame(height: 40)
                .padding(.horizontal, 25)
            ForEach(pokemonList.displayPokemons(with: store.appState.settings)) { pokemon in
                PokemonInfoRow(model: pokemon, expanded: self.pokemonList.selectionsState.isExpanding(pokemon.id))
                    .onTapGesture {
                        withAnimation(.spring(response: 0.55, dampingFraction: 0.425, blendDuration: 0)) {
                            self.store.dispatch(.toggleListSelection(index: pokemon.id))
                            self.store.dispatch(.loadAbilities(pokemon: pokemon.pokemon))
                        }
                }
            }
            Spacer()
                .frame(height: 8)
        }
//        .overlay(
//            VStack {
//                Spacer()
//                PokemonInfoPanel(model: .sample(id: 1))
//            }
//            .edgesIgnoringSafeArea(.bottom)
//        )
    }
}

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList()
    }
}
