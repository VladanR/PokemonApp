//
//  PokemonListViewModel.swift
//  PokemonApp
//
//  Created by Vladan Randjelovic on 10.5.24..
//

import Foundation

class PokemonListViewModel {
    
    private let pokemonManager          : PokemonManaging
    var pokemonList                     = [Pokemon]()
    var pokemonDetails                  : DetailPokemon?
    
    
    init(pokemonManager: PokemonManaging, completion: @escaping ([Pokemon]?, Error?) -> Void) {
        self.pokemonManager = pokemonManager
        pokemonManager.getPokemon { (pokemons, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            self.pokemonList = pokemons ?? []
            completion(pokemons, nil)
        }
    }
    func getPokemonIndex (pokemon: Pokemon) -> Int {
        if let index =  self.pokemonList.firstIndex(of: pokemon) {
            return index + 1
        }
        return 0
    }
    
    func getPokemonIdFromUrl(url: String, completionHandler: @escaping (_ resultId: String?) -> (Void))   {
        if let range = url.range(of: "/pokemon/") {
            let removedUrlFroString = url[range.upperBound...]
            let pureId = String(removedUrlFroString.dropLast())
            completionHandler(pureId)
        }
    }
    
    func getDetails(pokemon: Pokemon) {
        let id = getPokemonIndex(pokemon: pokemon)
        pokemonManager.getDetailedPokemon(id: id) { data in
            DispatchQueue.main.async {
                self.pokemonDetails = data
            }
        }
    }
    
    func getDetailsWithId(id: Int) {
        pokemonManager.getDetailedPokemon(id: id) { data in
            DispatchQueue.main.async {
                self.pokemonDetails = data
            }
        }
    }
    
    func formatHeighWeight(value : Int) -> String {
        let dValue               = Double(value)
        let string               = String(format: "%.2f", dValue / 10)
        
        return string
    }
}
