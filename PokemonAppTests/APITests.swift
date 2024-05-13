//
//  APITests.swift
//  PokemonAppTests
//
//  Created by Vladan Randjelovic on 10.5.24..
//

import XCTest
@testable import PokemonApp

final class APITests: XCTestCase {
    
    var apiService: PokemonAPIService!
    
    override func setUp() {
        super.setUp()
        apiService = PokemonAPIService()
    }
    
    override func tearDown() {
        apiService = nil
        super.tearDown()
    }
    
    func testGetPokemonsWithInvalidURL() {
        let expectation = self.expectation(description: "Completion handler invoked with error for invalid URL.")
        apiService.getPokemons(url: "htp://invalidurl") { (result: [String]?, error) in XCTAssertNil(result)
            XCTAssertNotNil(error)
            if let error = error as NSError? {
                XCTAssertEqual(error.domain, "URL")
                XCTAssertEqual(error.code, -1)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetPokemonsWithValidURLReturnsData() {
        let expectation = self.expectation(description: "Completion handler invoked with valid data.")
        let json = "[\"Pikachu\", \"Bulbasaur\"]"
        let url = "https://pokeapi.co/api/v2/pokemon"
        //        URLProtocolMock.testURLs = [url: Data(json.utf8)]
        apiService.getPokemons(url: url) { (result: [String]?, error) in
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            XCTAssertEqual(result?.count, 2)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetPokemonDetailsWithInvalidURL() {
        let failureExpectation = self.expectation(description: "Failure handler invoked due to invalid URL.")
        
        apiService.getPokemonDetails(url: "htp://invalidurl", model: Pokemon.self,
                                     completion: { _ in XCTFail("Completion should not be called.") },
                                     failure: { error in
            XCTAssertNotNil(error)
            failureExpectation.fulfill()
        })
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetPokemonDetails() {
        let expectation = XCTestExpectation(description: "Fetch Pokémon details")
        let url = "https://pokeapi.co/api/v2/pokemon/1/"
        
        apiService.getPokemonDetails(url: url, model: Pokemon.self, completion: { (pokemon: Pokemon) in
            XCTAssertNotNil(pokemon)
            expectation.fulfill()
        }, failure: { (error) in
            XCTFail("Failed to fetch Pokémon details: \(error.localizedDescription)")
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
}
    
    extension APITests {
//        static var allTests = [
//            ("testGetPokemonsWithInvalidURL", testGetPokemonsWithInvalidURL),
//            ("testGetPokemonsWithValidURLButHTTPError", testGetPokemonsWithValidURLButHTTPError),
//            ("testGetPokemonsWithValidURLReturnsData", testGetPokemonsWithValidURLReturnsData),
//            ("testGetPokemonDetailsWithInvalidURL", testGetPokemonDetailsWithInvalidURL),
//            ("testGetPokemonDetailsWithHTTPError", testGetPokemonDetailsWithHTTPError),
//            ("testGetPokemonDetailsSuccessfulDecode", testGetPokemonDetailsSuccessfulDecode)
//        ]
    }


