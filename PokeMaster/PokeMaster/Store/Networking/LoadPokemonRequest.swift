//
//  LoadPokemonRequest.swift
//  PokeMaster
//
//  Created by 杨冬青 on 2020/6/18.
//  Copyright © 2020 杨冬青. All rights reserved.
//

import Foundation
import Combine

struct LoadPokemonRequest {
    let id: Int
    
    static var all: AnyPublisher<[PokemonViewModel], AppError> {
        (1...30).map {
            LoadPokemonRequest(id: $0).publisher
        }.zipAll
    }
    
    var publisher: AnyPublisher<PokemonViewModel, AppError> {
        pokemonPublisher(id)
            .flatMap { self.speciesPubliser($0) }
            .map{ PokemonViewModel(pokemon: $0, species: $1) }
            .mapError { AppError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func pokemonPublisher(_ id: Int) -> AnyPublisher<Pokemon, Error> {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Pokemon.self, decoder: appDecoder)
            .eraseToAnyPublisher()
    }
    
    func speciesPubliser(_ pokemon: Pokemon) -> AnyPublisher<(Pokemon, PokemonSpecies), Error> {
        URLSession.shared.dataTaskPublisher(for: pokemon.species.url)
            .map { $0.data }
            .decode(type: PokemonSpecies.self, decoder: appDecoder)
            .map { (pokemon, $0) }
            .eraseToAnyPublisher()
    }
}
