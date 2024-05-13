//
//  PokemonListViewModelTests.swift
//  PokemonAppTests
//
//  Created by Vladan Randjelovic on 13.5.24..
//

import XCTest
@testable import PokemonApp

class PokemonListViewModelTests: XCTestCase {
    var viewModel: PokemonListViewModel!
    var mockPokemonManager: MockPokemonManager!
    
    override func setUp() {
        super.setUp()
        mockPokemonManager = MockPokemonManager()
        viewModel = PokemonListViewModel() { _, _ in }
    }
    
    override func tearDown() {
        viewModel = nil
        mockPokemonManager = nil
        super.tearDown()
    }
    
    func testInit_PokemonFetchedSuccessfully() {
        let pokemons = [Pokemon(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")]
        mockPokemonManager.mockPokemons = pokemons
        let expectation = self.expectation(description: "Fetching pokemon")
        viewModel = PokemonListViewModel { fetchedPokemons, error in
            XCTAssertNotNil(fetchedPokemons)
            XCTAssertTrue(fetchedPokemons!.count >= 1)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    func testInit_PokemonFetchFailed() {
        let error = NSError(domain: "com.pokemon.error", code: -1, userInfo: nil)
        mockPokemonManager.mockError = error
        
        let expectation = self.expectation(description: "Fetching pokemon")
        viewModel = PokemonListViewModel { fetchedPokemons, fetchError in
            XCTAssertNil(fetchedPokemons)
            XCTAssertNotNil(fetchError)
            XCTAssertEqual(fetchError as NSError?, error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    func testGetPokemonIndex_ValidPokemon() {
        viewModel.pokemonList = [Pokemon(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")]
        let pokemon = Pokemon(name: "Pikachu", url: "")
        
        let index = viewModel.getPokemonIndex(pokemon: pokemon)
        XCTAssertEqual(index, 0)
    }
    
    func testGetPokemonIndex_InvalidPokemon() {
        viewModel.pokemonList = [Pokemon(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/")]
        let pokemon = Pokemon(name: "Charmander", url: "")
        
        let index = viewModel.getPokemonIndex(pokemon: pokemon)
        XCTAssertEqual(index, 0)
    }
    func testGetPokemonIdFromUrl_ValidUrl() {
        let url = "https://pokeapi.co/api/v2/pokemon/25/"
        let expectation = self.expectation(description: "Extracting ID from URL")
        
        viewModel.getPokemonIdFromUrl(url: url) { resultId in
            XCTAssertEqual(resultId, "25")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testGetPokemonIdFromUrl_InvalidUrl() {
        let url = "https://pokeapi.co/api/v2/ability/4/"
        let expectation = self.expectation(description: "Extracting ID from URL")
        
        viewModel.getPokemonIdFromUrl(url: url) { resultId in
            XCTAssertNil(resultId)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
    }
    
    func testFormatHeightWeight() {
        XCTAssertEqual(viewModel.formatHeighWeight(value: 300), "30.00")
        XCTAssertEqual(viewModel.formatHeighWeight(value: 45), "4.50")
    }
    func testGetDetailsWithValidID() {
        let pokemon = Pokemon(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
        viewModel.pokemonList = [pokemon]
        
        let expectation = self.expectation(description: "Fetching details for Pokemon")
        viewModel.getDetails(pokemon: pokemon)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.viewModel.pokemonDetails)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    func testGetDetailsWithInvalidID() {
        let pokemon = Pokemon(name: "Unknown", url: "https://pokeapi.co/api/v2/pokemon/0.78gds/")
        viewModel.pokemonList = [pokemon]
        
        let expectation = self.expectation(description: "Fetching details for Non-Existing Pokemon")
        viewModel.getDetails(pokemon: pokemon)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNil(self.viewModel.pokemonDetails)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0)
    }
}

class MockPokemonManager: PokemonManager {
    var mockPokemons: [Pokemon]?
    var mockError: Error?
    override func getPokemon(completion: @escaping ([Pokemon]?, Error?) -> Void) {
        completion(mockPokemons, mockError)
    }
    
    //    override func getDetailedPokemon(id: Int, _ completion: @escaping (DetailPokemon?) -> Void) {
    //        if let data = mockPokemons?.first(where: { self.getPokemonIdFromUrl(url: $0.url) == "\(id)" }) {
    //            completion(DetailPokemon(id: 1, height: 20, weight: 100, name: "ditto", stats: [Stat(base_stat: 100)], types: [TypeElement(slot: 1, type: Species(name: "fire"))], base_experience: 50))
    //        } else {
    //            completion(nil)
    //        }
    //    }
    private func getPokemonIdFromUrl(url: String) -> String? {
        guard let range = url.range(of: "/pokemon/") else { return nil }
        let removedUrlFromString = url[range.upperBound...]
        return String(removedUrlFromString.dropLast())
    }
}
