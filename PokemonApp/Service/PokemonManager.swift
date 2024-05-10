//
//  PokemonAPIRequest.swift
//  PokemonApp
//
//  Created by Vladan Randjelovic on 10.5.24..
//

import Foundation

class PokemonManager {
    
    private struct Constants {
        static let baseUrl = "https://pokeapi.co/api/v2/"
    }
    
    func getPokemon(completion: @escaping ([Pokemon]?, Error?) -> Void) {
        let urlString = Constants.baseUrl + "pokemon?limit=100000&offset=0"
        PokemonAPIService().decode(url: urlString) { (pokemonPage: PokemonPage?, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let pokemons = pokemonPage?.results else {
                completion([], nil)
                return
            }
            
            completion(pokemons, nil)
        }
    }
    
    func getDetailedPokemon(id: Int, _ completion: @escaping (DetailPokemon) -> () ) {
        PokemonAPIService().fetchData(url: "https://pokeapi.co/api/v2/pokemon/\(id)", model: DetailPokemon.self) { data in
            completion(data)
        } failure: { error in
            print(error.localizedDescription)
        }
        
    }
}
