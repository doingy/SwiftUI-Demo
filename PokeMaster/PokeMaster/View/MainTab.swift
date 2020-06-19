//
//  MainTab.swift
//  PokeMaster
//
//  Created by 杨冬青 on 2020/6/17.
//  Copyright © 2020 杨冬青. All rights reserved.
//

import SwiftUI

struct MainTab: View {
    @EnvironmentObject var store: Store
    
    private var pokemonList: AppState.PokemonList {
        store.appState.pokemonList
    }
    
    private var pokemonListBinding: Binding<AppState.PokemonList> {
        $store.appState.pokemonList
    }
    
    private var selectedPanelIndex: Int? {
        pokemonList.selectionsState.panelIndex
    }
    
    var body: some View {
        TabView(selection: $store.appState.mainTab.selection) {
            PokemonRootView().tabItem {
                Image(systemName: "list.bullet.below.rectangle")
                Text("列表")
            }.tag(AppState.MainTab.Index.list)
            
            SettingsRootView().tabItem {
                Image(systemName: "gear")
                Text("设置")
            }.tag(AppState.MainTab.Index.settings)
        }
        .overlaySheet(isPresented: pokemonListBinding.selectionsState.panelPresented) {
            if self.selectedPanelIndex != nil && self.pokemonList.pokemons != nil {
                PokemonInfoPanel(model: self.pokemonList.pokemons![self.selectedPanelIndex!]!)
            }
        }
    }
    
    var panel: some View {
        Group {
            if pokemonList.selectionsState.panelPresented {
                if selectedPanelIndex != nil && pokemonList.pokemons != nil {
                    PokemonInfoPanelOverlay(model: pokemonList.pokemons![selectedPanelIndex!]!)
                } else {
                    EmptyView()
                }
            } else {
                EmptyView()
            }
        }
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
